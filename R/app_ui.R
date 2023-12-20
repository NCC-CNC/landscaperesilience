#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  add_resource_path("www", app_sys("app/www"))
  tagList(
    # HTML header
    tags$head(
      tags$link(rel="stylesheet", href="https://js.arcgis.com/4.28/esri/themes/light/main.css"),
      tags$script(src="https://js.arcgis.com/4.28/"),
      tags$script(type="module", src="www/main.js", defer=""),
      tags$link(rel="stylesheet", type="text/css", href="www/styles.css"),
    ),    
    shinyjs::useShinyjs(), # include shinyjs
    # Navigation bar page
    page_navbar(
      title = "Landscape Resilience Webtool",
      nav_panel(
        title = "Map",
        layout_sidebar(
          sidebar = sidebar(id = "Sidebar", width = "25%",
            navset_tab(
              nav_panel(
                title = "Stats",
                # Metrics popup (landR)
                tags$div(id="cardDiv1",
                 card(
                   full_screen = TRUE,
                   card_body(
                     tags$div(id="metricsDiv",
                              mod_metrics_bar_ui("metrics_bar_1")
                     )))),                
                
                # Histogram popup (landR)
                tags$div(id="cardDiv2",
                 card(
                   full_screen = TRUE,
                   card_body(
                     tags$div(id="histDiv", 
                       mod_histogram_popup_ui("histogram_popup_1")      
               ))))
            
               # Close nav panel
               )
            )
          ),
          # ESRI Map
          tags$div(id="viewDiv"),
          # Attribute table
          tags$div(class="tbl-container",
            tags$div(id="tableDiv")
          ),
          
          # Extraction controls
          tags$div(id="extractPanel",
            card( 
              max_height = 800,
              full_screen = FALSE,
              card_header("Zonal Stats"),
              card_body( 
                fluidRow(
                  column(10, mod_upload_data_ui("upload_data_1")),
                  column(2, mod_clear_data_ui("clear_data_1"))
                  ),
                fluidRow(
                  mod_name_from_user_poly_ui("name_from_user_poly_1")
                 ),
                fluidRow(
                  mod_upload_rasters_ui("upload_rasters_1")
                ),
                hr(), # section underline
                tags$div(class= "extract-download",
                fluidRow(
                  column(6, align = "center",
                  mod_extract_data_ui("extract_data_1")),
                  column(6, align = "center",
                  mod_download_data_ui("download_data_1")))
                )))),
        )
       )
      )
    )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "landscaperesilience"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
