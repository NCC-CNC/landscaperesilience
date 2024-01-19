// Display user geojson layer on map
export function mapUserGeojson(
  userGeojson,
  polyId,
  polyTitle,
  map,
  GeoJSONLayer,
  SimpleRenderer,
  SimpleFillSymbol,
  view
) {
  // create a new blob from geojson featurecollection
  let blob = new Blob([JSON.stringify(userGeojson)], {
    type: "application/json",
  });

  // URL reference to the blob
  let url = URL.createObjectURL(blob);

  // create new geojson layer using the blob url
  let geojsonLayer = new GeoJSONLayer({
    url: url,
    id: polyId,
    title: polyTitle,
  });

  // outline color
  let outline_color;
  let hash_color;
  if (polyId === "upload_poly") {
    outline_color = "rgba(99, 99, 99, 1)";
    hash_color = "rgba(99, 99, 99, 1)";
  } else {
    outline_color = "rgba(0, 0, 0, 1)";
    hash_color = "rgba(50, 50, 50, 0)";
    map.remove(map.findLayerById("upload_poly"));
  }

  // create render
  geojsonLayer.renderer = new SimpleRenderer({
    symbol: new SimpleFillSymbol({
      color: hash_color,
      style: "backward-diagonal",
      outline: {
        color: outline_color,
        width: "2px",
      },
    }),
  });

  // adds the layer to the map
  map.layers.add(geojsonLayer);

  // zoom to layer
  geojsonLayer.when(function () {
    view.extent = geojsonLayer.fullExtent;
  });

  // pass to R that the layer succesfully mapped
  if (geojsonLayer.declaredClass === "esri.layers.GeoJSONLayer") {
    Shiny.setInputValue("layer_mapped", true);
  } else {
    Shiny.setInputValue("layer_mapped", false);
  }
}
