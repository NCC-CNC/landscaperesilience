#' name_from_user_poly UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_name_from_user_poly_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::pickerInput(
      inputId = ns("PN"), 
      label = "Select a column that uniquely identifies polygons", 
      width = "100%",
      options = shinyWidgets::pickerOptions(
        noneSelectedText = "NA"),
      choices = c())
    )
}
    
#' name_from_user_poly Server Functions
#'
#' @noRd 
mod_name_from_user_poly_server <- function(id, path, user_poly_fields=NULL){
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    to_return <- reactiveValues(shp_name_field=NULL)
    
    observeEvent(path(), {
      # update name choices from user polygon
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "PN",
        label = "Select a column that uniquely identifies polygons",
        choices = c("Unsure? Use OID", user_poly_fields())
      )
    })
    
    # get field name
    observeEvent(input$PN, {
      to_return$shp_name_field <- reactive({ifelse(grepl("^Unsure\\?", input$PN), "OID", input$PN)})
    })
    
   return(to_return)  
  })
}
    
## To be copied in the UI
# mod_name_from_user_poly_ui("name_from_user_poly_1")
    
## To be copied in the server
# mod_name_from_user_poly_server("name_from_user_poly_1")
