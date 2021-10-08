import { Controller } from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

// import "chartjs-plugin-colorschemes";

export default class extends Controller {
  static targets = [ "chart"]
  static values = {
    dates: Array,
    events: Object,
    eventName: String,
  }

  connect() {
    this.showChart();
  }

  showChart() {
    const data = {
      labels: this.datesValue,
      datasets: Object.keys(this.eventsValue).map(e => this.createDataSet(e, this.eventsValue[e]))
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
          // Waiting for update to work with chart.js > 3.0
          // colorschemes: {
          //   scheme: 'brewer.Paired12'
          // },
          legend: {
             display: Object.keys(this.eventsValue).length != 1,
             position: 'bottom'
          }
        }
      }
    }

    var myChart = new Chart(
      this.chartTarget,
      config
    );
  }

  createDataSet(label, data) {
    return {
      label: label,
      backgroundColor: "rgb(255, 99, 0)",
      // random stuff while waiting for the colorschemes plugin update
      borderColor: `rgb(255, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)})`,
      data: data
    }
  }
}
