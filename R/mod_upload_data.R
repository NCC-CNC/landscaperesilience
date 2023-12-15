#' upload_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_upload_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(inputId = ns("upload_data"), label = NULL, multiple = TRUE)
  )
}
    
#' upload_data Server Functions
#'
#' @noRd 
mod_upload_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # reactive values to return
    to_return <- reactiveValues(user_poly=NULL, fields=NULL, path=NULL)
    path <- reactive({input$upload_data})
    shp <- read_shp(path) # fct_read_upload.R 
    fields <- reactive({ colnames(shp()) })
    observeEvent(path(), {
      # map: send upload to client
      send_geojson(session=session, user_poly=shp, poly_id="upload_poly", poly_title="Upload Polygon (No Data)")
      
      # return for extractions
      to_return$user_poly <- shp()
      to_return$fields <- fields()
      to_return$path <- path()

      # enable extraction button
      shinyjs::enable("name_from_user_poly_1-PN", asis= TRUE)
      shinyjs::enable("extract_data_1-extract_data", asis = TRUE)
      
    })
    return(to_return)
  })
}
    
## To be copied in the UI
# mod_upload_data_ui("upload_data_1")
    
## To be copied in the server
# mod_upload_data_server("upload_data_1")
