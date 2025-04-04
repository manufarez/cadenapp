import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="payments-filter"

export default class extends Controller {
  static targets = ["select", "list"];

  connect() {}

  filterPayments() {
    const participantId = this.selectTarget.value;
    const url = `${window.location.pathname}?participant_id=${participantId}`;

    fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
