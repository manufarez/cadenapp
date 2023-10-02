# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "alpinejs", to: "https://ga.jspm.io/npm:alpinejs@3.10.2/dist/module.esm.js"
pin "flowbite", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.8.1/flowbite.turbo.min.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
