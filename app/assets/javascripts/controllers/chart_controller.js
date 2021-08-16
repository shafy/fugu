import { Controller } from "stimulus"

import { Chart, registerables } from 'chart.js';
Chart.register(...registerables);

export default class extends Controller {
  /* static get targets() {
    return [ "chart" ]
  } */
  static targets = [ "chart"]
  static values = {
    events: Object,
    eventName: String,
  }

  connect() {
    this.showChart();
  }

  showChart() {
    const data = {
      labels: Object.keys(this.eventsValue),
      datasets: [
        {
          label: this.eventNameValue,
          backgroundColor: 'rgb(255, 99, 132)',
          borderColor: 'rgb(255, 99, 132)',
          data: Object.values(this.eventsValue),
        }
      ]
    };

    const config = {
      type: 'line',
      data,
      options: {
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
