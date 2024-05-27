// Display attribute table
export function dataPopup(userName, attr) {
  // Extract contribution to LandR fields
  const pVars = {};
  for (const key in attr) {
    if (key.startsWith("p")) {
      pVars[key] = attr[key];
    }
  }

  // Convert object entries to an array
  const pVarsArray = Object.entries(pVars);

  // Sort the array high to low based on the values
  pVarsArray.sort((a, b) => b[1] - a[1]);

  // Convert the sorted array back to an object
  const pVarsSorted = Object.fromEntries(pVarsArray);
  // Convert HFI and CLIMATE_E to negative
  pVarsSorted["pHFI"] = -Math.abs(pVarsSorted["pHFI"]);
  pVarsSorted["pCLIMATE_E"] = -Math.abs(pVarsSorted["pCLIMATE_E"]);

  // Contribution label mapping
  const pVarsLabels = {
    pBIOD_GOAL: "<span class='landr-biod'>Common Species Goal</span>",
    pBIOD_RICH: "<span class='landr-biod'>Common Species Richness</span>",
    pCH: "<span class='landr-biod'>Critical Habitat</span>",
    pCLIMATE_C: "<span class='landr-climate'>Climate Centrality</span>",
    pCLIMATE_R: "<span class='landr-climate'>Climate Refugia</span>",
    pCONNECT: "<span class='landr-connect'>Connectivity</span>",
    pEND_GOAL: "<span class='landr-biod'>Endemic Species Goal </span>",
    pEND_RICH: "<span class='landr-biod'>Endemic Species Richness </span>",
    pFOREST_LC: "<span class='landr-habitat'>Forest Landcover</span>",
    pGRASS: "<span class='landr-habitat'>Grassland</span>",
    pRIVER: "<span class='landr-habitat'>Rivers</span>",
    pSAR_GOAL: "<span class='landr-biod'>Species at Risk Goal</span>",
    pSAR_RICH: "<span class='landr-biod'>Species at Risk Richness</span>",
    pSHORE: "<span class='landr-habitat'>Shoreline</span>",
    pWET: "<span class='landr-habitat'>Wetland</span>",
    pHFI: "<span class='landr-threat'>Human Footprint</span>",
    pCLIMATE_E: "<span class='landr-threat'>Climate Extremes</span>",
  };

  // Get keys and values
  const pVarsKeys = Object.keys(pVarsSorted);
  const pVarsValues = Object.values(pVarsSorted);

  // Habitat ranking
  let hab = {};
  ["FOREST_LC", "FOREST_LU", "WET", "GRASS"].forEach((key) => {
    if (attr.hasOwnProperty(key)) {
      hab[key] = attr[key];
    }
  });

  // Convert object entries to an array
  const habArray = Object.entries(hab);

  // Sort the array based on the values
  habArray.sort((a, b) => b[1] - a[1]);

  // Convert the sorted array back to an object
  const habSorted = Object.fromEntries(habArray);

  // Habitat label mapping
  const habLabels = {
    FOREST_LC: "Forest Landcover",
    FOREST_LU: "Forest Landuse",
    GRASS: "Grassland",
    WET: "Wetland",
  };

  // Get keys and values
  const habKeys = Object.keys(habSorted);
  const habValues = Object.values(habSorted);

  // Build popup
  let popupTemplate = {
    title: attr[userName],
    collapsed: true,
    content: [
      {
        type: "text",
        text: ` <div class="landr-popup">
                <p> <span class="landr-title"><b> Landscape Resilience</b>: </span> 
                ${attr["LANDR"].toLocaleString()} <br>
                <b> Area </b>: ${attr["AREA_HA"].toLocaleString()} (ha) </p>
                <b>Contribution to Resilience:</b>
                <br>
                 01. ${pVarsLabels[pVarsKeys[0]]}, ${pVarsValues[0]}%
                <br>
                 02. ${pVarsLabels[pVarsKeys[1]]}, ${pVarsValues[1]}%
                <br>
                 03. ${pVarsLabels[pVarsKeys[2]]}, ${pVarsValues[2]}%
                <br>
                 04.  ${pVarsLabels[pVarsKeys[3]]}, ${pVarsValues[3]}%
                <br>
                 05. ${pVarsLabels[pVarsKeys[4]]}, ${pVarsValues[4]}%
                <br>
                 06. ${pVarsLabels[pVarsKeys[5]]}, ${pVarsValues[5]}%
                <br>
                 07. ${pVarsLabels[pVarsKeys[6]]}, ${pVarsValues[6]}%
                <br>
                 08. ${pVarsLabels[pVarsKeys[7]]}, ${pVarsValues[7]}%
                <br>
                 09. ${pVarsLabels[pVarsKeys[8]]}, ${pVarsValues[8]}%
                <br>
                 10. ${pVarsLabels[pVarsKeys[9]]}, ${pVarsValues[9]}%
                <br>
                 11. ${pVarsLabels[pVarsKeys[10]]}, ${pVarsValues[10]}%
                <br>
                 12. ${pVarsLabels[pVarsKeys[11]]}, ${pVarsValues[11]}%
                <br>
                 13. ${pVarsLabels[pVarsKeys[12]]}, ${pVarsValues[12]}%
                <br>
                 14. ${pVarsLabels[pVarsKeys[13]]}, ${pVarsValues[13]}%
                <br>
                 15. ${pVarsLabels[pVarsKeys[14]]}, ${pVarsValues[14]}%
                <br>
                 16. ${pVarsLabels[pVarsKeys[15]]}, ${pVarsValues[15]}%
                <br>
                 17. ${pVarsLabels[pVarsKeys[16]]}, ${pVarsValues[16]}%
                </p> 
                <p> <b> Habitat (ha): </b>
                <br>
                 ${habLabels[habKeys[0]]}: ${habValues[0].toLocaleString()}
                <br>
                 ${habLabels[habKeys[1]]}: ${habValues[1].toLocaleString()} 
                <br>
                 ${habLabels[habKeys[2]]}: ${habValues[2].toLocaleString()}
                <br>
                 ${habLabels[habKeys[3]]}: ${habValues[3].toLocaleString()}
                </p>
                <p> <b> Species Count: </b>
                <br>
                At Risk: ${attr["SAR_RICH"]} 
                <br>
                Endemics: ${attr["END_RICH"]} 
                <br>
                Common: ${attr["BIOD_RICH"]} 
                </p>
                <p> <b> Carbon: </b>
                <br>
                Potential:  ${attr["CARBON_P"].toLocaleString()} (t/year) <br> 
                Storage:    ${attr["CARBON_S"].toLocaleString()} (t)
                </p>
                <p> <b> Water: </b>
                <br>
                Lakes:  ${attr["LAKES"].toLocaleString()} (ha)    <br>
                Rivers:    ${attr["RIVER"].toLocaleString()} (km) <br>
                Shoreline: ${attr["SHORE"].toLocaleString()} (km)
                </p>
                </div>
                `,
      },
    ],
  };

  return popupTemplate;
}
