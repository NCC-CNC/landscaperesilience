import { mapUserGeojson } from "./map_geojson.js";
import { attributeTbl } from "./attribute_table.js";
import { dataPopup } from "./popups.js";
import { dataFields } from "./define_fields.js";

require([
  "esri/config",
  "esri/Map",
  "esri/views/MapView",
  "esri/layers/GeoJSONLayer",
  "esri/widgets/FeatureTable",
  "esri/widgets/LayerList",
  "esri/renderers/SimpleRenderer",
  "esri/symbols/SimpleFillSymbol",
  "esri/widgets/Expand",
  "esri/widgets/BasemapGallery",
  "esri/widgets/Histogram",
  "esri/popup/content/CustomContent",
], function (
  esriConfig,
  Map,
  MapView,
  GeoJSONLayer,
  FeatureTable,
  LayerList,
  SimpleRenderer,
  SimpleFillSymbol,
  Expand,
  BasemapGallery
) {
  // ESRI API
  Shiny.addCustomMessageHandler("send-api", function (message) {
    api = message[0];
    esriConfig.apiKey = api;
  });

  // init Map object
  const map = new Map({
    basemap: "topo-vector", // basemap styles service
  });

  // init MapView object
  const view = new MapView({
    map: map,
    center: [-106.3468, 56.1304], // Longitude, latitude
    zoom: 4, // Zoom level
    container: "viewDiv", // Div element
  });

  // add basemap gallery
  const basemapGallery = new BasemapGallery({
    view: view,
    container: document.createElement("div"),
  });

  const bgExpand = new Expand({
    expandIcon: "layers",
    view: view,
    content: basemapGallery,
  });

  view.ui.add(bgExpand, "top-left");

  // input polygon and extractions
  const expandContentDiv = document.getElementById("extractPanel");
  const expand = new Expand({
    content: expandContentDiv,
    expanded: true,
  });
  view.when(() => {
    view.ui.add(expand, "top-right");
  });

  // add layers to layer controls
  view.when(() => {
    const layerList = new LayerList({
      view: view,
    });
    view.ui.add(layerList, "top-left");
  });

  // map geojson
  Shiny.addCustomMessageHandler("send-geojson", function (message) {
    // remove data poly
    map.remove(map.findLayerById("data_poly"));

    let polyId = message[0];
    let polyTitle = message[1];
    let userGeojson = message[2];
    let userName = message[3];
    let rasterName = message[4];

    // display polygon
    mapUserGeojson(
      userGeojson,
      polyId,
      polyTitle,
      map,
      GeoJSONLayer,
      SimpleRenderer,
      SimpleFillSymbol,
      view
    );

    // add attribute table and popups
    if (polyId === "data_poly") {
      let geojsonLayer = map.findLayerById("data_poly");
      geojsonLayer.fields = dataFields(userName);
      geojsonLayer.outFields = ["*"];

      // popup with histogram
      let popupClick = 0;
      view.on("click", (event) => {
        view.hitTest(event).then(({ results }) => {
          let polyOID = results[0].graphic.attributes.OID;
          popupClick += 1;
          Shiny.setInputValue("popupClick", popupClick);
          Shiny.setInputValue("polyOID", polyOID);
          geojsonLayer.popupTemplate = dataPopup(userName);
        });
      });

      // remove all elements inside "#tableDiv"
      var tableDiv = document.getElementById("tableDiv");
      while (tableDiv.firstChild) {
        tableDiv.removeChild(tableDiv.firstChild);
      }
      // create FeatureTable
      attributeTbl(geojsonLayer, FeatureTable, view, userName, rasterName);

      // display FeatureTable
      let tblContainer = document.getElementsByClassName("tbl-container");
      let viewDiv = document.getElementById("viewDiv");
      tblContainer[0].classList.add("feature-table");
      viewDiv.classList.add("map-wth-feature-table");
    }
  });

  // clear geojson
  Shiny.addCustomMessageHandler("send-clear", function (message) {
    map.remove(map.findLayerById("upload_poly"));
    map.remove(map.findLayerById("data_poly"));
    let tableDiv = document.getElementById("tableDiv");
    let viewDiv = document.getElementById("viewDiv");
    tableDiv.innerHTML = "";
    viewDiv.classList.remove("map-wth-feature-table");
  });
});
