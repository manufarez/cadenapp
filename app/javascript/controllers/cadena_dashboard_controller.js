import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena-dashboard"
export default class extends Controller {
  static targets = ["details", "state", "chevron", "nextpayment"];
  static values = { state: String };

  initilize() {}

  connect() {
    if (this.stateValue === "finished") {
      this.toggleDetails();
    }
  }

  toggleDetails() {
    this.detailsTarget.classList.toggle("hidden");
    this.chevronTarget.classList.toggle("rotate-180");
    if (this.hasNextpaymentTarget) {
      this.nextpaymentTarget.classList.toggle("invisible");
    }
  }
}
