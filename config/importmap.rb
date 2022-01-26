# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
# pin "@rails/activestorage", to: "activestorage.esm.js"

# Use node modules from a JavaScript CDN by running ./bin/importmap

pin "application"

pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@3.7.0/dist/chart.esm.js"
# pin "chartjs-plugin-colorschemes", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"
pin "chartjs-plugin-datalabels", to: "https://ga.jspm.io/npm:chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.esm.js"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"

pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "chart.js/helpers", to: "https://ga.jspm.io/npm:chart.js@3.7.0/helpers/helpers.esm.js"
