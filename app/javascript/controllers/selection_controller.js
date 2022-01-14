import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  navigateToSelectUrl(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }
}
