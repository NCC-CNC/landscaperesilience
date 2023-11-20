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
    fileInput(inputId = ns("upld_data"), label = "", multiple = TRUE)
  )
}
    
#' upload_data Server Functions
#'
#' @noRd 
mod_upload_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_upload_data_ui("upload_data_1")
    
## To be copied in the server
# mod_upload_data_server("upload_data_1")
