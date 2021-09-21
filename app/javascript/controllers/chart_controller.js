import { Controller } from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  /* static get targets() {
    return [ "chart" ]
  } */
  static targets = [ "chart"]
  static values = {
    events: Array,
    eventName: String,
  }

  connect() {
    console.log(this.eventsValue)
    this.showChart();
  }

  showChart() {
    const data = {
      labels: this.eventsValue.map(e => e["date"]),
      datasets: [
        {
          label: this.eventNameValue,
          backgroundColor: "rgb(255, 99, 132)",
          borderColor: "rgb(255, 99, 132)",
          data: this.eventsValue.map(e => e["count"]),
        }
      ]
    };

    const config = {
      type: "line",
      data,
      options: {
        layout: {
          padding: 0
        },
        scales: {
          y: {
            grace: '10%',
            min: 0,
            ticks: {
              format: { style: "decimal", minimumFractionDigits: "0" },
              padding: 10,
            }
          }
        },
        spanGaps: true,
        plugins: {
          legend: {
             display: false,
          }
        }
      }
    }

    var myChart = new Chart(
      this.chartTarget,
      config
    );
  }
}
