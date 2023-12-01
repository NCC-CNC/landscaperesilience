// Display attribute table
export function dataPopup() {
  let popupTemplate = {
    title: "Impact Mertrics",
    content: [
      {
        type: "fields",
        fieldInfos: [
          {
            fieldName: "LANDR",
            label: "Resilience Score",
            format: {
              digitSeparator: true,
              places: 1,
            },
          },
          {
            fieldName: "FOREST_LC",
            label: "Forest (ha)",
            format: {
              digitSeparator: true,
              places: 1,
            },
          },
          {
            fieldName: "GRASS",
            label: "Grassland (ha)",
            format: {
              digitSeparator: true,
              places: 1,
            },
          },
          {
            fieldName: "WET",
            label: "Wetland (ha)",
            format: {
              digitSeparator: true,
              places: 1,
            },
          },
        ],
      },
    ],
  };
  return popupTemplate;
}
