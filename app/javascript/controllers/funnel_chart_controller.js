import { Controller } from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["chart"]
  static values = {
    funnelEventNames: Array,
    funnelData: Array,
  }

  connect() {
    this.initColorPalette();
    this.showChart();
  }

  showChart() {
    const data = {
      labels: this.funnelEventNamesValue,
      //datasets: Object.keys(this.funnelDataValue).map((f) => this.createDataSet(f, this.funnelDataValue[e]))
      datasets: this.createDataSet(this.funnelDataValue)
    };

    const config = {
      type: "bar",
      data,
      options: {
        layout: {
          padding: 10,
        },
        maintainAspectRatio: false,
        scales: {
          y: {
            grace: '10%',
            beginAtZero: true,
            ticks: {
              format: { style: "decimal" },
              precision: 0,
              padding: 10,
            },
            grid: {
              color: "rgba(254, 243, 199, 0.7)",
              lineWidth: 2,
              drawBorder: false
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        },
        //spanGaps: true,
        plugins: {
          legend: {
             display: this.displayLegend(),
             position: 'bottom'
          }
        }
      }
    }
    Chart.defaults.font.family = "'-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Oxygen-Sans', 'Ubuntu', 'Cantarell', 'Helvetica Neue', sans-serif";
    new Chart(
      this.chartTarget,
      config
    );
  }

  displayLegend() {
    return false;
    // let objKeys = Object.keys(this.eventsValue)
    // return objKeys.length != 1 || (objKeys.length === 1 && objKeys[0] !== "")
  }

  createDataSet(data) {
    return [{
      //label: this.htmlDecode(label),
      backgroundColor: this.colorPalette[0],
      borderColor: this.colorPalette[0],
      borderWidth: 0,
      borderRadius: 4,
      hoverBorderWidth: 4,
      hoverBorderColor: "rgb(35, 112, 144)",
      maxBarThickness: 100,
      data: data,
      //hidden: index > 5
    }]
  }

  initColorPalette() {
    this.colorPalette = [
      "rgb(39, 125, 161)",
      "rgb(87, 117, 144)",
      "rgb(77, 144, 142)",
      "rgb(67, 170, 139)",
      "rgb(144, 190, 109)",
      "rgb(249, 199, 79)",
      "rgb(249, 132, 74)",
      "rgb(248, 150, 30)",
      "rgb(243, 114, 44)",
      "rgb(249, 65, 68)"
    ]
  }

  // formatDates() {
  //   let dateOption;
  //   switch(this.aggValue) {
  //     case "d":
  //       dateOption = { weekday: "short", year: "2-digit", month: "short", day: "2-digit" };
  //       break;
  //     case "w":
  //       dateOption = { year: "numeric", month: "short", day: "2-digit" };
  //       break;
  //     case "m":
  //       dateOption = { year: "numeric", month: "short" };
  //       break;
  //     case "y":
  //       dateOption = { year: "numeric"};
  //       break;
  //   }
  //   return this.datesValue.map((e) => { 
  //     let d = new Date(e);
  //     return d.toLocaleDateString("en-US", dateOption);
  //   });
  // }

  htmlDecode(input) {
    var doc = new DOMParser().parseFromString(input, "text/html");
    return doc.documentElement.textContent;
  }
}
