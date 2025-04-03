# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "alpinejs", to: "https://ga.jspm.io/npm:alpinejs@3.10.2/dist/module.esm.js"
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
pin "vanilla-lazyload", to: "https://ga.jspm.io/npm:vanilla-lazyload@17.8.4/dist/lazyload.min.js"
pin "moment", to: "https://ga.jspm.io/npm:moment@2.30.1/moment.js"
pin "autonumeric", to: "https://ga.jspm.io/npm:autonumeric@4.10.5/dist/autoNumeric.min.js"
