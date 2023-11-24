#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  # File upload limit (1GB)
  options(shiny.maxRequestSize = 1000*1024^2) # 1GB
  
  # Get system environmental variables ----
  env_data <<- Sys.getenv("DATA_DIRECTORY")
  
  ## Assign wtw path globally ----
  if (nchar(env_data) > 0) {
    wtw_path <<- "/appdata/WTW_NAT_DATA_20231027"
  } else {
    wtw_path <<- "C:/Data/PRZ/WTW_DATA/WTW_NAT_DATA_20231027"
  }  
  
  ## disable buttons ----
  shinyjs::disable("extract_data_1-extract_data")
  shinyjs::disable("download_data_1-download_data")

  # user upload ----
  shp <- mod_upload_data_server(id = "upload_data_1")
  
  # send upload to client ----
  observeEvent(shp$user_poly,{
    send_geojson(session=session, user_poly= reactive(shp$user_poly))
  })
  
  # extract data ----
  ## enable extraction btn. if upload data successfully mapped
  observeEvent(input$layer_mapped, {
    if (isTruthy(input$layer_mapped)) {
      shinyjs::enable("extract_data_1-extract_data")
    }
  })
  ## extract data
  extracted <- mod_extract_data_server(
    id = "extract_data_1",
    user_poly= reactive(shp$user_poly), 
    wtw_path = wtw_path
  )
  
  # download data ----
  observeEvent(extracted$completed_run, {
    shinyjs::enable("download_data_1-download_data")
    mod_download_data_server(
      id = "download_data_1",
      user_poly_download =  reactive(extracted$user_poly_download)
    )
  })
  
  
# CLOSER SERVER  
}