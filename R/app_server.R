#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  ## disable buttons ----
  shinyjs::disable("extract_data_1-extract_data")

  # user upload ----
  shp <- mod_upload_data_server(id = "upload_data_1")
  
  # send upload to client ----
  observeEvent(shp$user_poly,{
    send_geojson(session=session, user_poly= reactive(shp$user_poly))
  })
  
  # extract data ----
  
# CLOSER SERVER  
}