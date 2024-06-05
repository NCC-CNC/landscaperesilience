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
      name: "LANDR",
      alias: "Resilience",
      type: "double",
    },
    {
      name: "rLANDR",
      alias: "Adjusted Resilience",
      type: "double",
    },
    {
      name: "CH",
      alias: "Critical Habitat (cumulative ha)",
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
      name: "CARBON_S",
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
      alias: "Forest LC (ha)",
      type: "double",
    },
    {
      name: "FOREST_LU",
      alias: "Forest LU (ha)",
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
    {
      name: "pCH",
      alias: "% Critical Habitat",
      type: "double",
    },
    {
      name: "pBIOD_GOAL",
      alias: "% Common Species Goal",
      type: "double",
    },
    {
      name: "pEND_GOAL",
      alias: "% Endemic Species Goal",
      type: "double",
    },
    {
      name: "pSAR_GOAL",
      alias: "% Species at Risk Goal",
      type: "double",
    },
    {
      name: "pBIOD_RICH",
      alias: "% Common Species Richness",
      type: "double",
    },
    {
      name: "pEND_RICH",
      alias: "% Endemic Species Richness",
      type: "double",
    },
    {
      name: "pSAR_RICH",
      alias: "% Species at Risk Richness",
      type: "double",
    },
    {
      name: "pCLIMATE_C",
      alias: "% Climate Centrality",
      type: "double",
    },
    {
      name: "pCLIMATE_R",
      alias: "% Climate Refugia",
      type: "double",
    },
    {
      name: "pCONNECT",
      alias: "% Connectivity",
      type: "double",
    },
    {
      name: "pFOREST_LC",
      alias: "% Forest",
      type: "double",
    },
    {
      name: "pGRASS",
      alias: "% Grassland",
      type: "double",
    },
    {
      name: "pRIVER",
      alias: "% Rivers",
      type: "double",
    },
    {
      name: "pWET",
      alias: "% Wetland",
      type: "double",
    },
    {
      name: "pSHORE",
      alias: "% Shoreline",
      type: "double",
    },
    {
      name: "pHFI",
      alias: "% Human Footprint",
      type: "double",
    },
    {
      name: "pCLIMATE_E",
      alias: "% Climate Extreme",
      type: "double",
    },
  ];
  return fields;
}
