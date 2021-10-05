# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
# pin "@rails/activestorage", to: "activestorage.esm.js"

# Use node modules from a JavaScript CDN by running ./bin/importmap

pin "application"

pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js/+esm"
pin "chartjs-plugin-colorschemes", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"

pin_all_from "app/javascript/controllers", under: "controllers"
