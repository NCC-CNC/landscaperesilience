#' concepts UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_concepts_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(class="concepts landr-webtool",
    fluidRow(column(12,
      htmltools::HTML(
      "The <b>Landscape Resilience Webtool</b> extracts spatial data standardized 
      at a 1km grid size to project boundaries. Use this tool to evaluate conservation values."
    )))),
    fluidRow(column(11,
    selectInput(
      inputId = ns("concept_selection"),
      label = NULL,
      choices = list(
        "Landscape Resilience" = "landR.html",
        "Biodiversity" = c(
          "Critical Habitat" = "ch.html", 
           "Species at Risk" = "sar.html", 
           "Endemic Species" = "end.html", 
           "Common Species" = "biod.html"
          ),
        "Connectivity" = c(
          "Connectivity" = "connect.html"
        ),
        "Climate" = c(
          "Climate Centrality" = "climate_c.html",
          "Climate Refugia" = "climate_r.html"
        ),
        "Habitat" = c(
          "Forest" = "forest_lc.html", 
          "Grassland" = "grass.html", 
          "Rivers" = "river.html",
          "Shoreline" = "shore.html",
          "Wetland" = "wet.html"
          ),
        "Threats" = c(
          "Human footprint" = "hfi.html",
          "Climate Extremes" = "climate_e.html"
        ),
        "Other Values" = c(
          "Carbon Storage" = "carbon_s.html",
          "Carbon Potential" = "carbon_p.html",
          "Freshwater Provision" = "freshw.html",
          "Lakes" = "lakes.html",
          "Recreation" = "rec.html",
          "Protected Areas" = "protected.html"
        )
       )
      )),
      column(1, 
      span(tooltip(bs_icon("info-circle"), 
        "Select conservation metric for details.")))),
    uiOutput(ns("concept_html"))
  )
}
    
#' concepts Server Functions
#'
#' @noRd 
mod_concepts_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$concept_selection, {
      output$concept_html <- renderUI(  
        htmltools::includeHTML(app_sys(file.path("app","www", "concepts", input$concept_selection))) 
      )
    }
  )
    
 
  })
}
    
## To be copied in the UI
# mod_concepts_ui("concepts_1")
    
## To be copied in the server
# mod_concepts_server("concepts_1")
