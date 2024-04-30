<template>
  <div class="canvas-container">
    <svg width="0" height="0" style="position: absolute; z-index: -1">
      <defs>
        <filter id="remove-alpha" x="0" y="0" width="100%" height="100%">
          <feComponentTransfer>
            <feFuncA type="discrete" tableValues="0 1"></feFuncA>
          </feComponentTransfer>
        </filter>
      </defs>
    </svg>
    <canvas ref="canvas" width="128" height="128" />
  </div>
</template>

<script>
export default {
  methods: {
    cls() {
      this.ctx.clearRect(
        0,
        0,
        this.$refs.canvas.width,
        this.$refs.canvas.height
      );
    },
    pset(x, y, color) {
      this.ctx.fillStyle = color;
      this.ctx.fillRect(x, y, 1, 1);
    },
    circ(x, y, r, color) {
      let x1 = r;
      let y1 = 0;
      let decisionOver2 = 1 - r;
      while (x1 >= y1) {
        this.pset(x + x1, y - y1, color);
        this.pset(x + y1, y - x1, color);
        this.pset(x - y1, y - x1, color);
        this.pset(x - x1, y - y1, color);
        this.pset(x - x1, y + y1, color);
        this.pset(x - y1, y + x1, color);
        this.pset(x + y1, y + x1, color);
        this.pset(x + x1, y + y1, color);
        y1++;
        if (decisionOver2 <= 0) {
          decisionOver2 += 2 * y1 + 1;
        } else {
          x1--;
          decisionOver2 += 2 * (y1 - x1) + 1;
        }
      }
    },
    circ_fast(x, y, r, color) {
      this.ctx.beginPath();
      this.ctx.arc(x, y, r, 0, 2 * Math.PI);
      this.ctx.strokeStyle = color;
      this.ctx.stroke();
    },
    circfill(x, y, r, color) {
      let x1 = r;
      let y1 = 0;
      let decisionOver2 = 1 - r;
      while (x1 >= y1) {
        for (let i = x - x1; i <= x + x1; i++) {
          this.pset(i, y - y1, color);
          this.pset(i, y + y1, color);
        }
        for (let i = x - y1; i <= x + y1; i++) {
          this.pset(i, y - x1, color);
          this.pset(i, y + x1, color);
        }
        y1++;
        if (decisionOver2 <= 0) {
          decisionOver2 += 2 * y1 + 1;
        } else {
          x1--;
          decisionOver2 += 2 * (y1 - x1) + 1;
        }
      }
    },
    circfill_fast(x, y, r, color) {
      this.ctx.beginPath();
      this.ctx.arc(x, y, r, 0, 2 * Math.PI);
      this.ctx.fillStyle = color;
      this.ctx.fill();
    },
  },
  mounted() {
    this.ctx = this.$refs.canvas.getContext("2d");
    this.ctx.imageSmoothingEnabled = false;
    // this.ctx.translate(0.5, 0.5);
    this.ctx.filter = "url(#remove-alpha)";
  },
};
</script>


<style scoped>
.canvas-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

canvas {
  width: 90%;
  background-color: #000;
  image-rendering: pixelated;
}
</style>