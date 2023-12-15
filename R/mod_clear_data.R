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
    actionButton(inputId = ns("clear_data"), icon = icon("ban"),  label = "", width = "100%")
  )
}
    
#' clear_data Server Functions
#'
#' @noRd 
mod_clear_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$clear_data, {
      
      # reset file input input
      shinyjs::reset("upload_data_1-upload_data", asis = TRUE)
      
      # reset picker input
      shinyjs::reset("name_from_user_poly_1-PN", asis = TRUE)
      
      # pass to client
      session$sendCustomMessage(
        type = "send-clear", message = TRUE
      )
      
      # disable buttons
      shinyjs::disable("name_from_user_poly_1-PN", asis= TRUE)
      shinyjs::disable("extract_data_1-extract_data", asis = TRUE)
      shinyjs::disable("download_data_1-download_data", asis= TRUE)
  
    })
 
  })
}
    
## To be copied in the UI
# mod_clear_data_ui("clear_data_1")
    
## To be copied in the server
# mod_clear_data_server("clear_data_1")
