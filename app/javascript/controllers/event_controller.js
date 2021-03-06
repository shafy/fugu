import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    aggregation: String
  }

  connect() {
    this.correctAggValue();
  }

  correctAggValue() {
    if(new URLSearchParams(window.location.search).get("agg") != null) {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", this.aggregationValue);
      history.replaceState(null, "", url);
    } else {
      return
    }
  }
}
