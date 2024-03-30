import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import moment from "moment";
import AutoNumeric from "autonumeric";

// Connects to data-controller="cadena"
export default class extends Controller {
  static targets = [
    "participants",
    "installments",
    "startDate",
    "endDate",
    "periodicity",
    "installmentValue",
    "installmentDisplay",
    "savingGoal",
    "savingGoalDisplay",
  ];

  connect() {
    this.installmentDisplayTarget.value = this.installmentValueTarget.value;
    new AutoNumeric("#installmentDisplay", {
      currencySymbol: " $",
      decimalCharacter: ",",
      digitGroupSeparator: ".",
      upDownStep: "10000",
    });
    flatpickr(".start_date", {
      dateFormat: "d/m/Y",
      defaultDate: this.startDateTarget.value,
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
    flatpickr(".end_date", {
      dateFormat: "d/m/Y",
      defaultDate: this.endDateTarget.value,
      clickOpens: false,
      disableMobile: "true",
    });
    this.updateEndDate();
    this.updateInstallments();
    this.updateSavingGoal();
  }

  updateEndDate() {
    const installments = parseInt(this.installmentsTarget.value, 10);
    const startDate = this.startDateTarget.value;
    const periodicity = this.periodicityTarget.value;

    if (installments && startDate) {
      let endDate = moment(startDate, "DD/MM/YYYY").subtract(1, "days");
      if (periodicity === "daily") {
        endDate = moment(endDate).add(installments, "days");
      } else if (periodicity === "monthly") {
        endDate = moment(endDate).add(installments, "months");
      } else if (periodicity === "bimonthly") {
        endDate = moment(endDate).add(installments * 15, "days");
      }
      this.endDateTarget.value = moment(endDate).format("DD/MM/YYYY");
    } else {
      this.endDateTarget.value = "";
    }
  }

  updateInstallments() {
    this.installmentsTarget.value = this.participantsTarget.value;
    this.updateSavingGoal();
  }

  updateSavingGoal() {
    const installmentsNumber = this.installmentsTarget.value;
    const installmentValue = AutoNumeric.getNumber("#installmentDisplay");
    if (installmentsNumber && installmentValue) {
      this.installmentValueTarget.value = installmentValue;
      const savingGoal = installmentsNumber * installmentValue;
      this.savingGoalTarget.value = savingGoal;
      this.savingGoalDisplayTarget.value = AutoNumeric.format(savingGoal, {
        currencySymbol: " $",
      });
    }
  }
}
