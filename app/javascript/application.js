// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
import LazyLoad from "vanilla-lazyload";
import Alpine from "alpinejs";
window.Alpine = Alpine;

document.addEventListener("DOMContentLoaded", function (event) {
  window.Alpine.start();
  new LazyLoad();
});
