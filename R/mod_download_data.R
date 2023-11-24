#' download_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_download_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    downloadButton(outputId = ns("download_data"), label = "Download Data", width = "100%")
  )
}
    
#' download_data Server Functions
#'
#' @noRd 
mod_download_data_server <- function(id, user_poly_download){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Time stamp for output folder
    datetime <- format(Sys.time(),"%Y%m%d%H%M%S")
    
    # Create temporary directory to save data
    td <- tempfile()
    dir.create(td, recursive = FALSE, showWarnings = FALSE)
    
    # Save shapefile to tmp director
    sf::write_sf(user_poly_download(), paste0(td, "/impact_metrics.shp"))
    
    # Zip
    files2zip <- list.files(td, full.names = TRUE, recursive = FALSE)
    utils::zip(zipfile = file.path(td, paste0("impact_metrics_", datetime, ".zip")),
               files = files2zip,
               flags = '-r9Xj') # flag so it does not take parent folders
    
    # set download button behavior
    output$download_data <- shiny::downloadHandler(
      filename <- function() {
        paste0("impact_metrics_", datetime, ".zip", sep="")
      },
      content <- function(file) {
        file.copy(file.path(td, paste0("impact_metrics_", datetime, ".zip")), file)
      },
      contentType = "application/zip"
    )    
    
 
  })
}
    
## To be copied in the UI
# mod_download_data_ui("download_data_1")
    
## To be copied in the server
# mod_download_data_server("download_data_1")
