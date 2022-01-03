import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    possibleAggregation: Array
  }

  connect() {
    this.correctAggValue();
  }

  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }

  correctAggValue() {
    if (new URLSearchParams(window.location.search).get("agg") == "d" && !this.possibleAggregationValue.includes("d")) {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", "w");
      history.replaceState(null, "", url);
     } else if(new URLSearchParams(window.location.search).get("agg") == "m" && !this.possibleAggregationValue.includes("m")) {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", "w");
      history.replaceState(null, "", url);
     } else if(new URLSearchParams(window.location.search).get("agg") == "y" && !this.possibleAggregationValue.includes("m") && !this.possibleAggregationValue.includes("y")) {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", "w");
      history.replaceState(null, "", url);
     } else if(new URLSearchParams(window.location.search).get("agg") == "y" && !this.possibleAggregationValue.includes("y")) {
      const url = new URL(window.location.href);
      url.searchParams.set("agg", "m");
      history.replaceState(null, "", url);
     } else {
       return;
     }
    
  }
}
