import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const customButton = this.element.querySelector("#custom-avatar-button");
    const avatarInput = this.element.querySelector("#avatar-input");
    const avatarFilename = this.element.querySelector("#avatar-filename");

    customButton.addEventListener("click", (e) => {
      e.preventDefault();
      avatarInput.click();
    });

    avatarInput.addEventListener("change", () => {
      const selectedFile = avatarInput.files[0];
      if (selectedFile) {
        if (selectedFile.name.length > 30) {
          avatarFilename.textContent = selectedFile.name.slice(0, 30) + "...";
        } else {
          avatarFilename.textContent = selectedFile.name;
        }
        avatarFilename.classList.add("text-white");
      }
    });
  }
}
