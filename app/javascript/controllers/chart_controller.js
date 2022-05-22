import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js";
import {
  LS_VISIBLE_PROP_VALUES,
  formatDates,
  formatLocalStorageName,
  htmlDecode,
  htmlLegendPlugin,
  initLocalStoragePropValues,
  localStorageItemJSON
} from "chart_helpers";

Chart.register(...registerables);

export default class extends Controller {
  static targets = [ "chart"]
  static values = {
    dates: Array,
    events: Object,
    agg: String,
    eventName: String,
    hasPropValues: Boolean,
    propertyName: String,
    projectId: String
  }

  connect() {
    //console.log("yo ", localStorage.getItem("visiblePropValues"))
    initLocalStoragePropValues(this.eventsValue, this.projectIdValue, this.propertyNameValue);
    this.visiblePropValues =  localStorageItemJSON(
                                formatLocalStorageName(
                                  this.projectIdValue,
                                  this.propertyNameValue,
                                  LS_VISIBLE_PROP_VALUES
                                )
                              );
    this.initColorPalette();
    this.showChart();
    // localStorage.setItem(
    //   "visiblePropValues",
    //   JSON.stringify(Object.keys(this.eventsValue).filter(v => this.eventsValue[v].visible))
    // );
  }

  showChart() {
    const data = {
      labels: formatDates(this.datesValue, this.aggValue),
      datasets: Object.keys(this.eventsValue).map((e, i) => this.createDataSet(e, this.eventsValue[e], i))
    };

    const config = {
      type: "line",
      data,
      options: {
        layout: {
          padding: 10,
        },
        maintainAspectRatio: false,
        scales: {
          y: {
            grace: "10%",
            beginAtZero: true,
            ticks: {
              format: { style: "decimal" },
              precision: 0,
              padding: 10
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
        spanGaps: true,
        plugins: {
          htmlLegend: {
            display: this.hasPropValuesValue,
            projectId: this.projectIdValue,
            propertyName: this.propertyNameValue
          },
          legend: {
            display: false
          }
        },
      },
      plugins: [ htmlLegendPlugin ]
    }
    Chart.defaults.font.family = "'-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Oxygen-Sans', 'Ubuntu', 'Cantarell', 'Helvetica Neue', sans-serif";
    this.chart = new Chart(
      this.chartTarget,
      config
    );
  }

  createDataSet(label, data, index) {
    return {
      label: `${htmlDecode(label)} (${data["total_count"]})`,
      backgroundColor: this.colorPalette[index % this.colorPalette.length],
      borderColor: this.colorPalette[index % this.colorPalette.length],
      borderJointStyle: "round",
      borderCapStyle: "round",
      borderWidth: 4.5,
      tension: 0.15,
      pointRadius: this.datesValue.length == 1 ? 1 : 0,
      pointHitRadius: 5,
      hoverBorderWidth: 4,
      data: data["data"],
      //hidden: !data["visible"]
      hidden: !this.visiblePropValues.includes(htmlDecode(label))
    }
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

  selectAllPropValues(e) {
    e.preventDefault();

    this.chart.data.datasets.forEach((dataset, index) => {
      this.chart.setDatasetVisibility(index, true);
    });
    this.chart.update();
  }

  deselectAllPropValues(e) {
    e.preventDefault();

    this.chart.data.datasets.forEach((dataset, index) => {
      this.chart.setDatasetVisibility(index, false);
    });
    this.chart.update();
  }
}
