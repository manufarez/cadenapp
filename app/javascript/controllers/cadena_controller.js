import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cadena"
export default class extends Controller {
  static targets = [
    "participants",
    "installments",
    "startDate",
    "endDate",
    "periodicity",
    "savingGoal",
    "installmentValue",
  ];

  connect() {
    this.updateEndDate();
    this.updateInstallments();
    this.updateSavingGoal();
  }

  updateEndDate() {
    const installments = parseInt(this.installmentsTarget.value, 10);
    const startDate = this.startDateTarget.value;
    const periodicity = this.periodicityTarget.value;

    if (installments && startDate) {
      const endDate = new Date(startDate);
      if (periodicity === "monthly") {
        endDate.setMonth(endDate.getMonth() + installments);
      } else if (periodicity === "bimonthly") {
        endDate.setDate(endDate.getDate() + installments * 15);
      }
      const formattedEndDate = endDate.toISOString().split("T")[0];
      this.endDateTarget.value = formattedEndDate;
    } else {
      this.endDateTarget.value = "";
    }
  }

  updateInstallments() {
    const participants = parseInt(this.participantsTarget.value, 10);
    if (!participants) return;
    this.installmentsTarget.value = participants.toString();
    this.updateSavingGoal();
  }

  updateSavingGoal() {
    const installments = parseInt(this.installmentsTarget.value, 10);
    const installmentValue = parseFloat(this.installmentValueTarget.value);
    if (installments && installmentValue) {
      const savingGoal = installments * installmentValue;
      this.savingGoalTarget.value = savingGoal.toFixed(2);
    } else {
      this.savingGoalTarget.value = 0;
    }
  }
}
