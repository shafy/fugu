import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "eventSelect",
    "aggSelect",
    "propertySelect",
    "dateSelect"
  ]

  static values = {
    dayNotAllowed: Boolean
  }

  connect() {
    this.correctAggValue();
    this.setSelectedOption(this.eventSelectTarget, "event");
    this.setSelectedOption(this.aggSelectTarget, "agg");
    this.setSelectedOption(this.propertySelectTarget, "prop");
    this.setSelectedOption(this.dateSelectTarget, "date");
  }

  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }

  setSelectedOption(selectElement, param) {
    console.log(window.location.search)
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

  correctAggValue() {
    // replace agg=d with agg=w if dayNotAllowedValue == true
    if (!this.dayNotAllowedValue) return;

    if (new URLSearchParams(window.location.search).get("agg") == "d") {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", "w");
      history.replaceState(null, "", url);
    }
  }
}
