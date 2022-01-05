import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    aggregation: String
  }

  connect() {
    this.correctAggValue();
  }

  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }

  correctAggValue() {
    const url = new URL(window.location.href);
    url.searchParams.set("agg", this.aggregationValue);
    history.replaceState(null, "", url);
  }
}
