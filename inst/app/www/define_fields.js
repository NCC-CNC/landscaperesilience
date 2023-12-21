// Display attribute table
export function dataFields(userName) {
  let fields = [
    {
      name: "OID",
      alias: "OID",
      type: "integer",
    },
    {
      name: userName,
      alias: "Name",
      type: "string",
    },
    {
      name: "AREA_HA",
      alias: "Area (ha)",
      type: "double",
    },
    {
      name: "LANDR_SUM",
      alias: "Resilience Sum",
      type: "double",
    },
    {
      name: "LANDR_MU",
      alias: "Resilience Mean",
      type: "double",
    },
    {
      name: "LANDR_MIN",
      alias: "Resilience MIN",
      type: "double",
    },
    {
      name: "LANDR_MAX",
      alias: "Resilience MAX",
      type: "double",
    },
    {
      name: "LANDR_SD",
      alias: "Resilience SD",
      type: "double",
    },
    {
      name: "SAR_RICH",
      alias: "Species at Risk (range count)",
      type: "double",
    },
    {
      name: "END_RICH",
      alias: "Endemic Species (count)",
      type: "double",
    },
    {
      name: "BIOD_RICH",
      alias: "Common Species (count)",
      type: "double",
    },
    {
      name: "CAROB_S",
      alias: "Carbon Storage (tonnes)",
      type: "double",
    },
    {
      name: "CARBON_P",
      alias: "Carbon Potential (tonnes/year)",
      type: "double",
    },
    {
      name: "CONNECT",
      alias: "Connectivity (current density)",
      type: "double",
    },
    {
      name: "CLIMATE_C",
      alias: "Climate Forward Shortest-Path Centrality (index)",
      type: "double",
    },
    {
      name: "CLIMATE_E",
      alias: "Extreme Heat Events (index)",
      type: "double",
    },
    {
      name: "CLIMATE_R",
      alias: "Climate Refugia (index)",
      type: "double",
    },
    {
      name: "FRESHW",
      alias: "Freshwater Provision (ha)",
      type: "double",
    },
    {
      name: "REC",
      alias: "Recreation (ha)",
      type: "double",
    },
    {
      name: "FOREST_LC",
      alias: "Forest (ha)",
      type: "double",
    },
    {
      name: "WET",
      alias: "Wetland (ha)",
      type: "double",
    },
    {
      name: "GRASS",
      alias: "Grassland (ha)",
      type: "double",
    },
    {
      name: "LAKES",
      alias: "Lakes (ha)",
      type: "double",
    },
    {
      name: "RIVER",
      alias: "Rivers (km)",
      type: "double",
    },
    {
      name: "SHORE",
      alias: "Shoreline (km)",
      type: "double",
    },
    {
      name: "PARKS",
      alias: "Protected Areas (ha)",
      type: "double",
    },
    {
      name: "HFI",
      alias: "Human Footprint (index)",
      type: "double",
    },
  ];
  return fields;
}
