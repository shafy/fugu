const htmlLegendPlugin = {
  id: "htmlLegend",
  afterUpdate(chart, _args, options) {
    if (!options.display) return;

    const propertyItemTemplate = document.getElementById("property-item-template");
    const propertiesSelected = document.getElementById("properties-selected").querySelector("ul");
    const propertiesUnselected = document.getElementById("properties-unselected").querySelector("ul");
    const items = chart.options.plugins.legend.labels.generateLabels(chart);

    // Remove old legend items
    while (propertiesSelected.firstChild) {
      propertiesSelected.firstChild.remove();
    }

    while (propertiesUnselected.firstChild) {
      propertiesUnselected.firstChild.remove();
    }

    // this.chart.data.datasets.forEach((dataset, index) => {
    //   this.chart.setDatasetVisibility(index, true);
    // });

    //console.log(chart.data.datasets)

    items.forEach(item => {
      //console.log(item)
      const propertyItem = propertyItemTemplate.content.cloneNode(true);
      const propertyItemContents = propertyItem.querySelectorAll("div");
      const colorBox = propertyItemContents[0];
      const textBox = propertyItemContents[1];

      const li = document.createElement("li");
      li.classList.add("property-item-li")
      li.appendChild(propertyItem)

      textBox.innerHTML = item.text;

      li.onclick = () => {
        chart.setDatasetVisibility(item.datasetIndex, !chart.isDatasetVisible(item.datasetIndex));
        chart.update();
      };

      if (item.hidden) {
        colorBox.classList.add("property-item-unselected--colorbox")
        textBox.classList.add("property-item-unselected--textbox")
        propertiesUnselected.appendChild(li);
        li.onmouseenter = () => {
          colorBox.style.background = item.fillStyle;
          colorBox.style.borderColor = item.strokeStyle;
          textBox.style.color = "initial";
        };
        li.onmouseleave = () => {
          colorBox.style.background = "rgb(229 231 235)";
          colorBox.style.borderColor = "rgb(229 231 235)";
          textBox.style.color = "rgb(156 163 175)";
        };
      } else {
        colorBox.style.background = item.fillStyle;
        colorBox.style.borderColor = item.strokeStyle;
        propertiesSelected.appendChild(li);
        li.onmouseenter = () => {
          colorBox.style.background = "rgb(229 231 235)";
          colorBox.style.borderColor = "rgb(229 231 235)";
          textBox.style.color = "rgb(156 163 175)";
        };
        li.onmouseleave = () => {
          colorBox.style.background = item.fillStyle;
          colorBox.style.borderColor = item.strokeStyle;
          textBox.style.color = "initial";
        };
      }
      
    })
  }
}

const formatDates = (datesValue, aggValue) => {
  let dateOption;
  switch(aggValue) {
    case "d":
      dateOption = { weekday: "short", year: "2-digit", month: "short", day: "2-digit" };
      break;
    case "w":
      dateOption = { year: "numeric", month: "short", day: "2-digit" };
      break;
    case "m":
      dateOption = { year: "numeric", month: "short" };
      break;
    case "y":
      dateOption = { year: "numeric"};
      break;
  }
  return datesValue.map((e) => { 
    let d = new Date(e);
    return d.toLocaleDateString("en-US", dateOption);
  });
}

const htmlDecode = (input) => {
  var doc = new DOMParser().parseFromString(input, "text/html");
  return doc.documentElement.textContent;
}

export { formatDates, htmlLegendPlugin, htmlDecode };
