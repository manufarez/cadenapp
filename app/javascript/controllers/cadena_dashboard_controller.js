import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena-dashboard"
export default class extends Controller {
  static targets = ["details", "status", "chevron", "nextpayment"];

  connect() {}

  toggleDetails() {
    this.detailsTarget.classList.toggle("hidden");
    this.chevronTarget.classList.toggle("rotate-180");
    if (this.hasNextpaymentTarget) {
      this.nextpaymentTarget.classList.toggle("invisible");
    }
  }
}
