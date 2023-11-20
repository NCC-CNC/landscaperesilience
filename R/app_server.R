#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  # user upload ----
  user_poly <- mod_upload_data_server(id = "upload_data_1")
  
# CLOSER SERVER  
}