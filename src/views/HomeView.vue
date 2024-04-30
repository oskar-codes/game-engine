<script setup lang="ts">
import TextEditor from '../components/TextEditor.vue';
import Renderer from '../components/Renderer.vue';
</script>

<template>
  <main>
    <nav>
      <h1>Game Engine</h1>
      <button v-if="!running" @click="run">▷</button>
      <button v-else @click="stop">■</button>
    </nav>

    <div class="content">
      <TextEditor v-model="code" :read-only="running" />
      <Renderer ref="renderer" />
    </div>
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100%;
}

main > .content {
  display: flex;
  flex-direction: row;
  height: calc(100vh - 36px);
}

main > .content > * {
  flex: 1;
}

main > nav {
  display: flex;
  justify-content: space-between;
}

button {
  padding: 8px 16px;
  border-radius: 5px;
  margin: 5px;
  background-color: var(--vt-c-indigo);
  color: white;
  border: none;
  cursor: pointer;
}
</style>


<script lang="ts">

const base = `

c={}
n=0
for i=1,10 do
  add(c,{
    c=i,
    r=200,
    x=cos(n)*32+64,
    y=sin(n)*32+64
  })
  n = n + 0.01
end

cls()
for i=0,200 do
  for c in all(c) do
    circfill(c.x,c.y,c.r,colors[c.c])
    c.r = c.r - 1
  end
end
`


export default {
  data() {
    return {
      code: base,
      running: false,
      worker: new Worker('worker.js')
    }
  },
  methods: {
    async run() {

      this.worker = new Worker('worker.js');
      this.worker.postMessage(this.code);
      this.running = true;

      this.worker.onmessage = ({ data }) => {
        
        if (data.type === 'output') {
          console.log(data.payload);

          this.worker.terminate();
          this.running = false;
        } else if (data.type === 'error_runtime' || data.type === 'error_load') {
          console.error(data.payload);

          this.worker.terminate();
          this.running = false;
        } else if (data.type === 'exit') {
          this.worker.terminate();
          this.running = false;
        } else if (data.type === 'alert') {
          alert(data.payload);
        } else if (data.type === 'render_call') {
          const { type, args } = data.payload;
          this.$refs.renderer[type](...args);
        }
      }
    },
    stop() {
      this.running = false;
      this.worker.terminate();
    }
  }
}
</script>