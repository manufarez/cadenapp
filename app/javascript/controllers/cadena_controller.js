import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

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
    flatpickr(".start_date", {
      dateFormat: "d/m/Y",
      defaultDate: this.startDateTarget.placeholder,
      locale: {
        firstDayOfWeek: 1,
        weekdays: {
          shorthand: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"],
          longhand: [
            "Domingo",
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado",
          ],
        },
        months: {
          shorthand: [
            "Ene",
            "Feb",
            "Mar",
            "Abr",
            "May",
            "Jun",
            "Jul",
            "Ago",
            "Sep",
            "Оct",
            "Nov",
            "Dic",
          ],
          longhand: [
            "Enero",
            "Febrero",
            "Мarzo",
            "Abril",
            "Mayo",
            "Junio",
            "Julio",
            "Agosto",
            "Septiembre",
            "Octubre",
            "Noviembre",
            "Diciembre",
          ],
        },
      },
    });
  }

  updateEndDate() {
    const installments = parseInt(this.installmentsTarget.value, 10);
    const startDate = this.startDateTarget.value.split("/").reverse().join("-");
    const periodicity = this.periodicityTarget.value;

    if (installments && startDate) {
      const endDate = new Date(startDate);
      if (periodicity === "daily") {
        endDate.setDate(endDate.getDate() + installments);
      } else if (periodicity === "monthly") {
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
