import { Controller } from "@hotwired/stimulus";
import { confetti } from "@tsparticles/confetti";

// Connects to data-controller="cadena-dashboard"
export default class extends Controller {
  static targets = ["details", "state", "chevron"];
  static values = { state: String };

  initilize() {}

  connect() {
    console.log("Connected cadena-dashboard controller");

    if (this.stateValue === "finished") {
      this.toggleDetails();
      this.fireConfetti();
    }
  }

  fireConfetti() {
    console.log("Firing confetti");
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.3 },
    });
  }

  toggleDetails() {
    this.detailsTarget.classList.toggle("hidden");
    this.chevronTarget.classList.toggle("rotate-180");
  }
}
