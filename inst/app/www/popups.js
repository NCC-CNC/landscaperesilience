// Display attribute table
export function dataPopup(userName, attr) {
  const pVars = {};
  for (const key in attr) {
    // Check if the key starts with the letter 'p'
    if (key.startsWith("p")) {
      // Add the key-value pair to the filtered object
      pVars[key] = attr[key];
    }
  }

  // Convert object entries to an array
  const pVarsArray = Object.entries(pVars);

  // Sort the array based on the values
  pVarsArray.sort((a, b) => b[1] - a[1]);

  // Convert the sorted array back to an object
  const pVarsSorted = Object.fromEntries(pVarsArray);

  // label mapping
  const pVarsLabels = {
    pBIOD_GOAL: "Common Species Goal",
    pBIOD_RICH: "Common Species Richness",
    pCH: "Critical Habitat",
    pCLIMATE_C: "Climate Centrality",
    pCLIMATE_R: "Climate Refugia",
    pCONNECT: "Connectivity",
    pEND_GOAL: "Endemic Species Goal",
    pEND_RICH: "Endemic Species Richness",
    pFOREST: "Forest",
    pGRASS: "Grassland",
    pSAR_GOAL: "Species at Risk Goal",
    pSAR_RICH: "Species at Risk Richness",
    pSHORE: "Shoreline",
    pWET: "Wetland",
  };

  // Get keys and values
  const pVarsKeys = Object.keys(pVarsSorted);
  const pVarsValues = Object.values(pVarsSorted);

  // Hab
  let hab = {};
  ["FOREST", "WET", "GRASS"].forEach((key) => {
    if (attr.hasOwnProperty(key)) {
      // Add the key-value pair to the filtered object
      hab[key] = attr[key];
    }
  });

  // Convert object entries to an array
  const habArray = Object.entries(hab);

  // Sort the array based on the values
  habArray.sort((a, b) => b[1] - a[1]);

  // Convert the sorted array back to an object
  const habSorted = Object.fromEntries(habArray);

  // label mapping
  const habLabels = {
    FOREST: "Forest",
    GRASS: "Grassland",
    WET: "Wetland",
  };

  // Get keys and values
  const habKeys = Object.keys(habSorted);
  const habValues = Object.values(habSorted);

  let popupTemplate = {
    title: "Landscape Resilience",
    collapsed: true,
    content: [
      {
        type: "fields",
        fieldInfos: [
          {
            fieldName: userName,
            label: userName,
          },
          {
            fieldName: "LANDR",
            label: "Resilience",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
          {
            fieldName: "AREA_HA",
            label: "Area (ha)",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
        ],
      },
      {
        type: "text",
        text: `<p><b>Top variables contributing to Resilience:</b>
                <ol> 
                  <li> 
                  ${pVarsLabels[pVarsKeys[0]]} (${pVarsValues[0]}%)
                  </li>
                  <li> 
                  ${pVarsLabels[pVarsKeys[1]]} (${pVarsValues[1]}%)
                  </li>
                  <li> 
                  ${pVarsLabels[pVarsKeys[2]]} (${pVarsValues[2]}%)
                  </li>
                  <li> 
                  ${pVarsLabels[pVarsKeys[3]]} (${pVarsValues[3]}%)
                  </li>
                  <li> 
                  ${pVarsLabels[pVarsKeys[4]]} (${pVarsValues[4]}%)
                  </li>
                 </ol>
                </p>  
                <p> <b> Leading Habitat (ha): </b>
                <br>
                    ${habLabels[habKeys[0]]}: ${habValues[0].toLocaleString()},
                    ${habLabels[habKeys[1]]}: ${habValues[1].toLocaleString()}, 
                    ${habLabels[habKeys[2]]}: ${habValues[2].toLocaleString()}
                </p>
                <p> <b> Species Count: </b>
                <br>
                  At Risk: ${attr["SAR_RICH"]},
                  Endemics: ${attr["END_RICH"]},
                  Common: ${attr["BIOD_RICH"]} 
                </p>
                <p> <b> Carbon: </b>
                <br>
                  Potential:  ${attr["CARBON_P"].toLocaleString()} (t), 
                  Storage:    ${attr["CARBON_S"].toLocaleString()} (t/year)
                </p>
                `,
      },
    ],
  };

  return popupTemplate;
}
