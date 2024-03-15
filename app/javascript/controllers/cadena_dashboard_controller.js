import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena-dashboard"
export default class extends Controller {
  static targets = ["details", "state", "chevron"];
  static values = { state: String };

  initilize() {}

  connect() {
    if (this.stateValue === "finished") {
      this.toggleDetails();
      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.3 },
      });
    }
  }

  toggleDetails() {
    this.detailsTarget.classList.toggle("hidden");
    this.chevronTarget.classList.toggle("rotate-180");
  }
}
