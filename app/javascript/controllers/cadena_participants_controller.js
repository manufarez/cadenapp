import { Controller } from "@hotwired/stimulus";
import LazyLoad from "vanilla-lazyload";

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
    new LazyLoad();
    if (this.hasPeriodProgressTarget) {
      this.periodProgressTarget.style.width =
        this.periodProgressTarget.dataset.periodProgress + "%";
    }
  }

  showPeriod() {
    this.toggleView();
    this.tab1Target.classList.add("bg-primary_blue", "hover:bg-blue-700");
    this.tab2Target.classList.remove("bg-primary_blue", "hover:bg-blue-700");
    this.tab1Target.classList.remove("hover:bg-midnight");
    this.tab2Target.classList.add("hover:bg-midnight");
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

  showGlobal() {
    this.toggleView();
    this.tab1Target.classList.remove("bg-primary_blue", "hover:bg-blue-700");
    this.tab2Target.classList.add("bg-primary_blue", "hover:bg-blue-700");
    this.tab2Target.classList.remove("hover:bg-midnight");
    this.tab1Target.classList.add("hover:bg-midnight");
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

  toggleView() {
    this.periodTarget.classList.toggle("hidden");
    this.globalTarget.classList.toggle("hidden");
  }
}
