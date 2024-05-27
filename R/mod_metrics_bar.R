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
      fluidRow(column(11,
        selectInput(
          inputId = ns("impact"),
          label = NULL,
          choices = c(
            "Landscape Resilience" = "LANDR",
            "Adjusted Landscape Resilience" = "rLANDR",
            "Area (ha)" = "AREA_HA",
            "Species at Risk (count)" = "SAR_RICH",
            "Endemic Species (count)" = "END_RICH",
            "Common Species (count)" = "BIOD_RICH",
            "Forest Landcover (ha)" = "FOREST_LC",
            "Forest Landuse (ha)" = "FOREST_LU",
            "Wetland (ha)" = "WET",
            "Grassland (ha)" = "GRASS",
            "Lakes (ha)" = "LAKES",
            "Rivers (km)" = "RIVER",
            "Shoreline (km)" = "SHORE",
            "Carbon Storage (tonnes)" = "CARBON_S",
            "Carbon Potential (tonnes per year)" = "CARBON_P",
            "Connectivity (current density)" = "CONNECT",
            "Climate Centrality (index)" = "CLIMATE_C",
            "Climate Extremes (index)" = "CLIMATE_E",
            "Climate Refugia (index)" = "CLIMATE_R",
            "Freshwater Provision (index)" = "FRESHW",
            "Recreation (index)" = "REC",
            "Protected (ha)" = "PARKS",
            "Human footprint (index)" = "HFI"
            ))),
        column(1, 
          span(tooltip(bs_icon("info-circle"), 
            "Select variable to view and compare between all unique polygons. Run zonal statistics to enable this chart.")))
      ),
      highcharter::highchartOutput(outputId = ns("barpopup"), height = "calc(50vh - 149px)")
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
      
      index <- order(df[[metric]], decreasing = TRUE)
      
      # Update metrics bar  
      highcharter::highchartProxy("metrics_bar_1-barpopup") %>%
        highcharter::hcpxy_remove_series(all=TRUE) %>%
        highcharter::hcpxy_add_series(
          type= "bar",
          data = df[[metric]][index],
          pointPadding = 0, groupPadding = 0, borderWidth = 0, pointWidth = 10,
          color = "#33862B",
          mapping = highcharter::hcaes(x = .df[shp_name_field()], y = .df[metric])
        ) %>%
        highcharter::hcpxy_update(
          xAxis = list(
            categories = df[[shp_name_field()]][index], # user column
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
