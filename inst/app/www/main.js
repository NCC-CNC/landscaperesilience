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
  "esri/layers/TileLayer",
  "esri/widgets/Legend",
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
  BasemapGallery,
  TileLayer,
  Legend
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
    center: [-95, 64], // Longitude, latitude
    zoom: 4, // Zoom level
    container: "viewDiv", // Div element
  });

  // add basemap gallery
  const basemapGallery = new BasemapGallery({
    view: view,
    container: document.createElement("div"),
  });

  // add resilience layer
  let landR = new TileLayer({
    url: "https://tiles.arcgis.com/tiles/etzrVYxPRxn7Nirj/arcgis/rest/services/LandR_tiles/MapServer",
    opacity: 0.75,
    title: "Landscape Resilience",
    listMode: "hide-children",
  });
  map.layers.add(landR);

  const bgExpand = new Expand({
    expandIcon: "layers",
    view: view,
    collapseTooltip: "Collapse Baselayers",
    expandTooltip: "Expand Baselayers",
    content: basemapGallery,
  });

  view.ui.add(bgExpand, "top-left");

  // add layers to layer controls
  const layerList = new LayerList({
    view: view,
    listItemCreatedFunction: (event) => {
      const item = event.item;
      if (item.layer.type != "group") {
        // don't show legend twice
        item.panel = {
          content: "legend",
          open: false,
          style: "card",
        };
      }
    },
  });

  const layerExpand = new Expand({
    expandIcon: "polygon",
    view: view,
    content: layerList,
    collapseTooltip: "Collapse Layer",
    expandTooltip: "Expand Layer",
    expanded: true,
  });

  view.when(() => {
    view.ui.add(layerExpand, "top-left");
  });

  // input polygon and extractions
  const expandContentDiv = document.getElementById("extractPanel");
  const expand = new Expand({
    content: expandContentDiv,
    collapseTooltip: "Collapse Zonal Statistics",
    expandTooltip: "Expand Zonal Statistics",
    expandIcon: "file",
    expanded: true,
  });
  view.when(() => {
    view.ui.add(expand, "top-right");
  });

  // attribute table
  const expandTblDiv = document.getElementById("tableDiv");
  const expandTbl = new Expand({
    content: expandTblDiv,
    expanded: true,
    collapseTooltip: "Collapse Attribute Table",
    expandTooltip: "Expand Attribute Table",
    expandIcon: "table",
  });
  view.when(() => {
    view.ui.add(expandTbl, "bottom-left");
  });

  // map geojson
  Shiny.addCustomMessageHandler("send-geojson", function (message) {
    // remove data poly
    map.remove(map.findLayerById("data_poly"));

    // get R server data
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
      let tableDiv = document.getElementById("tableDiv");
      while (tableDiv.firstChild) {
        tableDiv.removeChild(tableDiv.firstChild);
        tblDiv.style.height = "0px";
      }
      // create FeatureTable
      attributeTbl(geojsonLayer, FeatureTable, view, userName, rasterName);

      // display FeatureTable
      let tblHeight = userGeojson.features.length * 25 + 125;
      tblHeight = tblHeight > 300 ? "300px" : `${tblHeight}px`;
      tableDiv.style.height = tblHeight;
    }

    // hide spinner
    const spinner = document.querySelector(".spinner");
    spinner.style.display = "none";
  });

  // clear geojson
  Shiny.addCustomMessageHandler("send-clear", function (message) {
    map.remove(map.findLayerById("upload_poly"));
    map.remove(map.findLayerById("data_poly"));
    let tableDiv = document.getElementById("tableDiv");
    tableDiv.innerHTML = "";
    tableDiv.style.height = "0px";
  });
});
