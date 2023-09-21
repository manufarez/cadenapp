import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["element"];

  static values = {
    start: Number,
    end: Number,
    duration: Number,
  };

  connect() {
    this.animate();
  }

  animate() {
    let startTimestamp = null;

    const step = (timestamp) => {
      if (!startTimestamp) startTimestamp = timestamp;

      const elapsed = timestamp - startTimestamp;
      const progress = Math.min(elapsed / this.durationValue, 1);

      const formatter = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
        useGrouping: "auto",
        minimumFractionDigits: 0,
      });

      const number = Math.floor(
        progress * (this.endValue - this.startValue) + this.startValue
      ).toString();

      this.elementTarget.innerHTML = formatter.format(number);

      if (progress < 1) {
        window.requestAnimationFrame(step);
      }
    };

    window.requestAnimationFrame(step);
  }
}
