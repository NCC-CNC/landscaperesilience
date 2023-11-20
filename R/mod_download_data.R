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
    actionButton(inputId = ns("dwnld_data"), label = "Download Data", width = "100%")
  )
}
    
#' download_data Server Functions
#'
#' @noRd 
mod_download_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_download_data_ui("download_data_1")
    
## To be copied in the server
# mod_download_data_server("download_data_1")
