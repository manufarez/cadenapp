import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena-period"
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
    this.periodProgressTarget.style.width =
      this.periodProgressTarget.dataset.periodProgress + "%";
  }

  showPeriod() {
    this.periodTarget.classList.remove("hidden");
    this.globalTarget.classList.add("hidden");
    this.tab1Target.classList.add("bg-primary_blue");
    this.tab1Target.classList.add("hover:bg-blue-700");
    this.tab1Target.classList.remove("hover:bg-midnight");
    this.tab2Target.classList.remove("bg-primary_blue");
    this.tab2Target.classList.remove("hover:bg-blue-700");
    this.tab2Target.classList.add("hover:bg-midnight");
    setTimeout(() => {
      this.periodProgressTarget.style.width =
        this.periodProgressTarget.dataset.periodProgress + "%";
    }, "1");
    this.globalProgressTarget.style.width = "0%";
  }

  showGlobal() {
    this.periodTarget.classList.add("hidden");
    this.globalTarget.classList.remove("hidden");
    this.tab2Target.classList.add("bg-primary_blue");
    this.tab1Target.classList.remove("bg-primary_blue");
    this.tab2Target.classList.add("hover:bg-blue-700");
    this.tab2Target.classList.remove("hover:bg-midnight");
    this.tab1Target.classList.add("hover:bg-blue-700");
    this.tab1Target.classList.add("hover:bg-midnight");
    setTimeout(() => {
      this.globalProgressTarget.style.width =
        this.globalProgressTarget.dataset.globalProgress + "%";
    }, "1");
    this.periodProgressTarget.style.width = "0%";
  }
}
