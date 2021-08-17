Rails.application.config.importmap.draw do
  pin "@hotwired/stimulus", to: "stimulus.js"
  pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"
  pin_all_from "app/javascript/controllers", under: "controllers"

  pin "application"

  pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js/+esm"

  # Use libraries available via the asset pipeline (locally or via gems).
  # pin "@rails/actioncable", to: "actioncable.esm.js"
  # pin "@rails/activestorage", to: "activestorage.esm.js"

  # Use libraries directly from JavaScript CDNs (see https://www.skypack.dev, https://esm.sh, https://www.jsdelivr.com/esm)
  # pin "vue", to: "https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.esm.browser.js"
  # pin "d3", to: "https://esm.sh/d3?bundle"

  # Pin vendored modules by first adding the following to app/assets/config/manifest.js:
  # //= link_tree ../../../vendor/assets/javascripts .js
  # pin_all_from "vendor/assets/javascripts"
end
