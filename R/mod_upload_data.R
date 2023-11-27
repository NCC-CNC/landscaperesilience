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
    to_return <- reactiveValues(user_poly=NULL)
    path <- reactive({input$upload_data})
    shp <- read_shp(path) # fct_read_upload.R 
    observeEvent(path(), {
      # map: send upload to client
      send_geojson(session=session, user_poly= shp)
      # return for extractions
      to_return$user_poly <- shp()
    })
    return(to_return)
  })
}
    
## To be copied in the UI
# mod_upload_data_ui("upload_data_1")
    
## To be copied in the server
# mod_upload_data_server("upload_data_1")
