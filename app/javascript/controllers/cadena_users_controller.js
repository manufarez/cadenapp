import { Controller } from "@hotwired/stimulus";
import LazyLoad from "vanilla-lazyload";

// Connects to data-controller="cadena-users"
export default class extends Controller {
  connect() {
    new LazyLoad();
  }
}
