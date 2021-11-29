import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    dayNotAllowed: Boolean
  }

  connect() {
    this.correctAggValue();
  }

  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
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
