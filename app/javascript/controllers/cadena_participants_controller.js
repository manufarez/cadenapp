import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena-participants"
export default class extends Controller {
  static targets = [
    "period",
    "global",
    "tab1",
    "tab2",
    "globalProgress",
    "periodProgress",
  ];

  connect() {
    if (this.hasPeriodProgressTarget) {
      this.periodProgressTarget.style.width =
        this.periodProgressTarget.dataset.periodProgress + "%";
    }
  }

  showPeriod() {
    if (!this.tab1Target.classList.contains("active-period")) {
      this.toggleView();
      this.tab2Target.classList.replace("active-period", "hover:bg-midnight");
      this.tab1Target.classList.replace("hover:bg-midnight", "active-period");
      if (this.hasPeriodProgressTarget) {
        setTimeout(() => {
          this.periodProgressTarget.style.width =
            this.periodProgressTarget.dataset.periodProgress + "%";
        }, "1");
      }
      if (this.hasGlobalProgressTarget) {
        this.globalProgressTarget.style.width = "0%";
      }
    }
  }

  showGlobal() {
    if (!this.tab2Target.classList.contains("active-period")) {
      this.toggleView();
      this.tab1Target.classList.replace("active-period", "hover:bg-midnight");
      this.tab2Target.classList.replace("hover:bg-midnight", "active-period");
      if (this.hasGlobalProgressTarget) {
        setTimeout(() => {
          this.globalProgressTarget.style.width =
            this.globalProgressTarget.dataset.globalProgress + "%";
        }, "1");
      }
      if (this.hasPeriodProgressTarget) {
        this.periodProgressTarget.style.width = "0%";
      }
    }
  }

  toggleView() {
    this.periodTarget.classList.toggle("hidden");
    this.globalTarget.classList.toggle("hidden");
  }
}
