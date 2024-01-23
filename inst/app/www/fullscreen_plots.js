export function fullScreenPlots() {
  // Select the bslib card and plot elements
  const targetElements = document.querySelectorAll(
    ".bslib-card[data-full-screen]"
  ); // Select by presence of data-full-screen attribute
  const metricsElement = document.querySelector("#metrics_bar_1-barpopup");
  const histElement = document.querySelector("#histogram_popup_1-histpopup");

  // Create a MutationObserver for each target element
  targetElements.forEach((targetElement) => {
    // Create a MutationObserver instance
    const observer = new MutationObserver(function (mutations) {
      // Handle the changes here
      mutations.forEach(function (mutation) {
        // Check if the attribute is data-full-screen
        if (
          mutation.type === "attributes" &&
          mutation.attributeName === "data-full-screen"
        ) {
          // Check the new value of data-full-screen
          const newFullScreenValue =
            targetElement.getAttribute("data-full-screen");

          // React accordingly to the new value
          if (newFullScreenValue === "true") {
            // Set the height of plots
            metricsElement.style.height = "calc(100vh - 250px)";
            histElement.style.height = "calc(100vh - 250px)";
          } else if (newFullScreenValue === "false") {
            // Reset the height of plots
            metricsElement.style.height = "calc(50vh - 155px)";
            histElement.style.height = "calc(50vh - 155px)";
          }
        }
      });
    });

    // Configure the observer to watch for attribute changes
    const config = { attributes: true };

    // Start observing the target element
    observer.observe(targetElement, config);
  });
}
