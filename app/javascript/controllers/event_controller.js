import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "eventSelect",
    "aggSelect",
    "propertySelect",
    "dateSelect"
  ]

  static values = {
    events: Array,
    eventName: String,
  }

  connect() {
    this.setSelectedOption(this.eventSelectTarget, "event")
    this.setSelectedOption(this.aggSelectTarget, "agg"),
    this.setSelectedOption(this.propertySelectTarget, "prop")
    this.setSelectedOption(this.dateSelectTarget, "date")
  }

  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }

  setSelectedOption(selectElement, param) {
    let paramValue = new URLSearchParams(window.location.search).get(param)

    if (!paramValue) {
      selectElement.selectedIndex = 0
      return
    }

    let options = selectElement.options
    for (let i = 0; i < options.length; i++) {
      if (options[i].dataset.name == paramValue) {
        selectElement.selectedIndex = i
        break
      }
    }
  }
}
