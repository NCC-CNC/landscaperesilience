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
  env_wtw <<- Sys.getenv("WTW_NAT_DATA")
  env_esri <<- Sys.getenv("ESRI_API")
  
  ## Assign wtw path globally ----
  if (nchar(env_wtw) > 0) {
    wtw_path <<- "/WTW_NAT_DATA" # server (production)
  } else {
    wtw_path <<- "C:/Data/PRZ/WTW_DATA/WTW_NAT_DATA_20240110" # Dan Wismer local (dev)
  }  
  
  ## Assign esri API globally ----
  if (nchar(env_esri) > 0) {
    esri_maps_api <<- readLines("/license/esri_maps_sdk.txt") # server (production)
  } else {
    esri_maps_api <<- readLines("C:/API_KEYS/esri_maps_sdk.txt") # Dan Wismer local (dev)
  }  
  # send api to client
  session$sendCustomMessage(
    type = "send-api", message = list(esri_maps_api)
  )
  
  ## disable buttons ----
  shinyjs::disable("name_from_user_poly_1-PN")
  shinyjs::disable("extract_data_1-extract_data")
  shinyjs::disable("download_data_1-download_data")
  shinyjs::disable("metrics_bar_1-impact")

  # user upload ----
  shp <- mod_upload_data_server(id = "upload_data_1")
  # clear user upload ----
  mod_clear_data_server(id = "clear_data_1")
  
  # get polygon fields ----
  shp_name_field <- mod_name_from_user_poly_server(
    id = "name_from_user_poly_1",
    path = reactive(shp$path),
    user_poly_fields = reactive(shp$fields)
   )

  # get user .tif(s)
  tif_data <- mod_upload_rasters_server(id = "upload_rasters_1")
  
  # extract data ----
  extracted <- mod_extract_data_server(
    id = "extract_data_1",
    user_poly = reactive(shp$user_poly), 
    wtw_path = wtw_path,
    shp_name_field = shp_name_field$shp_name_field,
    tif_data = tif_data,
    shp_name = reactive(shp$shp_name)
  )
  
  # sidebar popup ----
  observeEvent(list(extracted$completed_run, input[["metrics_bar_1-impact"]]), {
    # barplot:impact metrics
    mod_metrics_bar_server(
    id = "metrics_bar_1",
    user_poly = reactive(extracted$user_poly_download),
    metric = input[["metrics_bar_1-impact"]],
    shp_name_field = shp_name_field$shp_name_field
  ) 
  }, ignoreNULL= FALSE)
  
  
  # sidebar popup ----
  observeEvent(input$polyOID, {
    # histogram:landr
    mod_histogram_popup_server(
      id ="histogram_popup_1",
      landr_tbl = extracted$landr_tbl,
      oid = input$polyOID,
      shp_name = shp_name_field$shp_name_field,
      user_poly = reactive(extracted$user_poly_download)
    )
  }, ignoreNULL= FALSE)
  
  
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