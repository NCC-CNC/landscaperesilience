#' tbl_popup UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tbl_popup_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactable::reactableOutput(outputId = ns("tblpopup")),
  )
}
    
#' tbl_popup Server Functions
#'
#' @noRd 
mod_tbl_popup_server <- function(id, landr_tbl, oid, n_click){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # get lanrR values
    landr_values <- unname(unlist(landr_tbl[[oid]][1]))
    
    # get summary values
    min_value <- min(landr_values) %>% round(2)
    mean_value <- mean(landr_values) %>% round(2)
    med_value <- median(landr_values) %>% round(2)
    sum_value <- sum(landr_values) %>% round(2)
    max_value <- max(landr_values) %>% round(2)
    sd_value <- sd(landr_values) %>% round(2)
    
    # build df
    landr_df <- data.frame(
      "Sum" = sum_value,
      "Min" = min_value,
      "Mean" = mean_value,
      "Med" = med_value,
      "Max" = max_value
    )
    
    output$tblpopup <- reactable::renderReactable({
      reactable::reactable(landr_df)
    })
  })
}
    
## To be copied in the UI
# mod_tbl_popup_ui("tbl_popup_1")
    
## To be copied in the server
# mod_tbl_popup_server("tbl_popup_1")
