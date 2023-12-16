#' metrics_bar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_metrics_bar_ui <- function(id){
  ns <- NS(id)
  tagList(
    tagList(
      selectInput(
        inputId = ns("impact"),
        label = NULL,
        choices = c(
          "Landscape Resilience Score" = "LANDR_SUM",
          "Species at Risk (count)" = "SAR_RICH",
          "Endemic Species (count)" = "END_RICH",
          "Common Species (count)" = "BIOD_RICH",
          "Forest (ha)" = "FOREST_LC", 
          "Wetland (ha)" = "WET",
          "Grassland (ha)" = "GRASS",
          "Rivers (km)" = "RIVER",
          "Shoreline (km)" = "SHORE"
          )
      ),
      highcharter::highchartOutput(outputId = ns("barpopup"), height = "325px")
    )
  )
}
    
#' metrics_bar Server Functions
#'
#' @noRd 
mod_metrics_bar_server <- function(id, user_poly = NULL, metric = NULL, shp_name_field = NULL) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    if (is.null(user_poly())) {
      # empty bar chart
      b <- empty_metrics_bar()
      output$barpopup <- highcharter::renderHighchart({ b })
      
    } else {

      df <- user_poly() %>%
        st_drop_geometry() 
      
      x_names <- unname(unlist(df[shp_name_field()]))
      
      # Update metrics bar  
      highcharter::highchartProxy("metrics_bar_1-barpopup") %>%
        highcharter::hcpxy_remove_series(all=TRUE) %>%
        highcharter::hcpxy_add_series(
          type= "bar",
          data = df[[metric]],
          pointPadding = 0, groupPadding = 0, borderWidth = 0, pointWidth = 10,
          color = "#7A59FC",
          mapping = highcharter::hcaes(x = .df[shp_name_field()], y = .df[metric])
        ) %>%
        highcharter::hcpxy_update(
          xAxis = list(
            categories = x_names,
            title = ""),
          subtitle = list(
            text=""
            ),
          yAxis = list(
            title = ""
          )
        )
    }
 })
}
    
## To be copied in the UI
# mod_metrics_bar_ui("metrics_bar_1")
    
## To be copied in the server
# mod_metrics_bar_server("metrics_bar_1")
