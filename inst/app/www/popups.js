// Display attribute table
export function dataPopup(userName) {
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
            fieldName: "LANDR_SUM",
            label: "Score",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
          {
            fieldName: "LANDR_MIN",
            label: "Min",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
          {
            fieldName: "LANDR_MAX",
            label: "Max",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
          {
            fieldName: "LANDR_MU",
            label: "Mean",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
          {
            fieldName: "LANDR_SD",
            label: "Standard Deviation",
            format: {
              digitSeparator: true,
              places: 2,
            },
          },
        ],
      },
    ],
  };

  return popupTemplate;
}
