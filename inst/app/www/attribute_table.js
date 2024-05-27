// Display attribute table
export function attributeTbl(
  geojsonLayer,
  FeatureTable,
  view,
  userName,
  rasterName
) {
  const featureTable = new FeatureTable({
    view: view,
    layer: geojsonLayer,
    multiSortEnabled: true,
    tableTemplate: {
      // autocastable to TableTemplate
      // The table template's columnTemplates are used to determine which attributes are shown in the table
      columnTemplates: [
        {
          type: "field",
          fieldName: userName,
          label: userName,
        },
        {
          type: "field",
          fieldName: "AREA_HA",
          label: "Area (ha)",
        },
        {
          type: "field",
          fieldName: "LANDR",
          label: "Resilience",
        },
        {
          type: "field",
          fieldName: "rLANDR",
          label: "Adjusted Resilience",
        },
        {
          type: "field",
          fieldName: "SAR_RICH",
          label: "Species at Risk (range count)",
        },
        {
          type: "field",
          fieldName: "END_RICH",
          label: "Endemic Species (count)",
        },
        {
          type: "field",
          fieldName: "BIOD_RICH",
          label: "Common Species (count)",
        },
        {
          type: "field",
          fieldName: "FOREST_LC",
          label: "Forest Landcover (ha)",
        },
        {
          type: "field",
          fieldName: "FOREST_LU",
          label: "Forest Landuse (ha)",
        },
        {
          type: "field",
          fieldName: "WET",
          label: "Wetland (ha)",
        },
        {
          type: "field",
          fieldName: "GRASS",
          label: "Grassland (ha)",
        },
        {
          type: "field",
          fieldName: "LAKES",
          label: "Lakes (ha)",
        },
        {
          type: "field",
          fieldName: "RIVER",
          label: "Rivers (km)",
        },
        {
          type: "field",
          fieldName: "SHORE",
          label: "Shoreline (km)",
        },
        {
          type: "field",
          fieldName: "CARBON_S",
          label: "Carbon Storage (tonnes)",
        },
        {
          type: "field",
          fieldName: "CARBON_P",
          label: "Carbon Potential (tonnes/year)",
        },
        {
          type: "field",
          fieldName: "CONNECT",
          label: "Connectivity (current density)",
        },
        {
          type: "field",
          fieldName: "CLIMATE_C",
          label: "Climate Forward Shortest-Path Centrality (index)",
        },
        {
          type: "field",
          fieldName: "CLIMATE_E",
          label: "Extreme Heat Events (index)",
        },
        {
          type: "field",
          fieldName: "CLIMATE_R",
          label: "Climate Refugia (index)",
        },
        {
          type: "field",
          fieldName: "FRESHW",
          label: "Freshwater Provision (ha)",
        },
        {
          type: "field",
          fieldName: "REC",
          label: "Recreation (ha)",
        },
        {
          type: "field",
          fieldName: "PARKS",
          label: "Protected Areas (ha)",
        },
        {
          type: "field",
          fieldName: "HFI",
          label: "Human Footprint (index)",
        },
        {
          type: "field",
          fieldName: rasterName,
          label: rasterName,
        },
      ],
    },
    container: document.getElementById("tableDiv"),
  });
  return featureTable;
}
