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
    downloadButton(outputId = ns("download_data"), label = "Download", width = "100%")
  )
}
    
#' download_data Server Functions
#'
#' @noRd 
mod_download_data_server <- function(id, user_poly_download, shp_name){
  moduleServer( id, function(input, output, session){
    
    ns <- session$ns
    
    # Input polygon name
    shp_name <- substr(shp_name(), 1, nchar(shp_name()) - 4)
    
    # Time stamp for output folder
    datetime <- format(Sys.time(),"%Y%m%d%H%M%S")
    
    # Create temporary directory to save data
    td <- tempfile()
    dir.create(td, recursive = FALSE, showWarnings = FALSE)
    
    # Get normalized and percent columns
    landr_norm <-  user_poly_download() %>% 
      st_drop_geometry() %>%
      select(-c(LANDR:HFI))
    
    # Drop normalized and percent columns in sf
    user_poly_to_download <- user_poly_download() %>%
      select(1:which(names(user_poly_download()) == "HFI"))
    
    # Save shapefile to tmp director
    sf::write_sf(user_poly_to_download, paste0(td, "/", shp_name, "_LandR.shp"))
    
    # Generate total table
    total_tbl <- tot_tbl(user_poly_to_download)
    
    # Get metadata table
    meta_tbl <- read.csv(system.file("extdata", "metadata.csv", package="landscaperesilience"))
    
    # Save xlsx to tmp director
    sf::write_sf(user_poly_to_download, paste0(td, "/", shp_name, "_LandR.xlsx"))
    wb <- loadWorkbook(paste0(td, "/", shp_name, "_LandR.xlsx"))
    renameWorksheet(wb, paste0(shp_name, "_LandR"), "Data-Raw") # rename tab
    
    # add new sheets
    addWorksheet(wb,"Totals")
    writeData(wb,"Totals", total_tbl)
    addWorksheet(wb,"Data-Normalized")
    writeData(wb,"Data-Normalized", landr_norm)    
    addWorksheet(wb,"metadata")
    writeData(wb,"metadata", meta_tbl)
    
    # Style excel
    modifyBaseFont(wb, fontSize = 11, fontColour = "black", fontName = "Calibri")
    header_style <- createStyle(fgFill = "#2D602E", halign = "CENTER", textDecoration = "Bold", fontColour = "white")
    addStyle(wb, sheet = 1, style = header_style, rows = 1, cols = 1:ncol(user_poly_to_download), gridExpand = TRUE)
    addStyle(wb, sheet = 2, style = header_style, rows = 1, cols = 1:2, gridExpand = TRUE)
    addStyle(wb, sheet = 3, style = header_style, rows = 1, cols = 1:ncol(landr_norm), gridExpand = TRUE)
    addStyle(wb, sheet = 4, style = header_style, rows = 1, cols = 1:6, gridExpand = TRUE)
    saveWorkbook(wb, paste0(td, "/", shp_name, "_LandR.xlsx"), overwrite = TRUE)
    
    # Zip
    files2zip <- list.files(td, full.names = TRUE, recursive = FALSE)
    utils::zip(zipfile = file.path(td, paste0("LandR_", datetime, ".zip")),
               files = files2zip,
               flags = '-r9Xj') # flag so it does not take parent folders
    
    # set download button behavior
    output$download_data <- shiny::downloadHandler(
      filename <- function() {
        paste0("LandR_", datetime, ".zip", sep="")
      },
      content <- function(file) {
        file.copy(file.path(td, paste0("LandR_", datetime, ".zip")), file)
      },
      contentType = "application/zip"
    )    
  })
}
    
## To be copied in the UI
# mod_download_data_ui("download_data_1")
    
## To be copied in the server
# mod_download_data_server("download_data_1")
