#' extract data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_extract_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    tagList(
      actionButton(inputId = ns("extract_data"), label = "Extract Data", width = "100%")
    )
  )
}
    
#' extract data Server Functions
#'
#' @noRd 
mod_extract_data_server <- function(id, user_data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
  })
}
    
## To be copied in the UI
# mod_extract_ui("extract_1")
    
## To be copied in the server
# mod_extract_server("extract_1")
