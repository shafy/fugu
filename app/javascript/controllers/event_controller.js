import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "eventSelect"]

  static values = {
    events: Array,
    eventName: String,
  }

  connect() {
    this.setSelectedEvent()
  }

  showEvent(event) {
    window.location.href = event.currentTarget.selectedOptions[0].dataset.url;
  }

  setSelectedEvent() {
    let currentEvent = new URLSearchParams(window.location.search).get("event")

    if (!currentEvent) {
      this.eventSelectTarget.selectedIndex = 0
      return
    }

    let options = this.eventSelectTarget.options
    for (let i = 0; i < options.length; i++) {
      if (options[i].dataset.name == currentEvent) {
        this.eventSelectTarget.selectedIndex = i
        break
      }
    }
  }
}
