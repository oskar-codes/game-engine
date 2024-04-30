<script setup lang="ts">
import hljs from 'highlight.js';
import CodeEditor from 'simple-code-editor';
</script>

<template>
  <div>
    <CodeEditor
      v-model="code"
      :line-nums="true"
      :languages="[['lua', 'Lua']]"
      width="100%"
      height="100%"
      :read-only="readOnly"
      theme="atom-one-dark" />
  </div>
</template>

<style scoped>
textarea {
  width: 100%;
  height: 100%;
  resize: none;
  font-size: 1.5rem;
  border: none;
  outline: none;
  background-color: #000;
  color: #fff;
}
</style>

<script lang="ts">
export default {
  props: {
    modelValue: String,
    readOnly: Boolean
  },
  emits: ['update:modelValue'],
  data() {
    return {
      code: `function init()
      
end

function update()

end`
    }
  },
  watch: {
    code() {
      this.$emit('update:modelValue', this.code);
    },
    modelValue: {
      immediate: true,
      handler(value) {
        this.code = value;
      }
    }
  },
}
</script>