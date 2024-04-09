import React from "react";

class Background extends React.Component {
  canvasRef = React.createRef();

  componentDidMount() {
    this.updateCanvasSize();
    window.addEventListener("resize", this.updateCanvasSize);
    this.animate();
  }

  componentWillUnmount() {
    window.removeEventListener("resize", this.updateCanvasSize);
  }

  updateCanvasSize = () => {
    const canvas = this.canvasRef.current;
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    this.drawBackground();
  };

  drawBackground = () => {
    const ctx = this.canvasRef.current.getContext("2d");
    const gradient = ctx.createLinearGradient(0, 0, window.innerWidth, window.innerHeight);
    gradient.addColorStop(0, "rgba(251,63,220,1)");
    gradient.addColorStop(1, "rgba(105,70,252,1)");

    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, window.innerWidth, window.innerHeight);
  };

  animate = () => {
    requestAnimationFrame(this.animate);
    const ctx = this.canvasRef.current.getContext("2d");
    this.drawBackground(); // Redraw the background to avoid trails

    // Lines properties
    const linesCount = 100;
    const linesColor = "rgba(255,255,255,0.2)";
    const maxLineHeight = 15;
    const lineHeightVariance = Math.random() * maxLineHeight;

    // Draw moving lines
    for (let i = 0; i < linesCount; i++) {
      const x = Math.random() * window.innerWidth;
      const y = Math.random() * window.innerHeight;
      ctx.beginPath();
      ctx.moveTo(x, y);
      ctx.lineTo(x + lineHeightVariance, y + lineHeightVariance);
      ctx.strokeStyle = linesColor;
      ctx.stroke();
    }
  };

  render() {
    return (
      <canvas
        ref={this.canvasRef}
        style={{
          position: "absolute",
          top: 0,
          left: 0,
          zIndex: -1,
          width: "100%",
          height: "100%",
        }}
      />
    );
  }
}

export default Background;
