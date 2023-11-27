#' clear_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_clear_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("clear_data"), label = "Clear", width = "100%")
  )
}
    
#' clear_data Server Functions
#'
#' @noRd 
mod_clear_data_server <- function(id, id_to_clear){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$clear_data, {
      
      # reset file input input
      shinyjs::reset(id_to_clear, asis = TRUE)
      
      # pass to client
      session$sendCustomMessage(
        type = "send-clear", message = TRUE
      )
      
      # disable buttons
      shinyjs::disable("extract_data_1-extract_data", asis = TRUE)
      shinyjs::disable("download_data_1-download_data", asis= TRUE)
  
    })
 
  })
}
    
## To be copied in the UI
# mod_clear_data_ui("clear_data_1")
    
## To be copied in the server
# mod_clear_data_server("clear_data_1")
