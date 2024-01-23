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
    prompter::use_prompt(), # include prompter (using for tool tips)
    # Navigation bar page
    page_navbar(
      title = img(class="logo", src = "www/NCC_Icon_Logo_KO_F.png"),
      underline = FALSE,
      window_title = "LandR",
      nav_panel(
        title = tags$div(class="app-title", "Landscape Resilience Webtool"),
        layout_sidebar(
          sidebar = sidebar(id = "Sidebar", width = "27.5%",
            # Stats 
            navset_tab(
              nav_panel(
                title = "Stats",
                # Metrics popup (landR)
                tags$div(id="cardDiv1",
                 card(
                   full_screen = TRUE,
                   fill = TRUE,
                   card_body(
                     tags$div(id="metricsDiv",
                              mod_metrics_bar_ui("metrics_bar_1"))))),                
                # Histogram popup (landR)
                tags$div(id="cardDiv2",
                 card(
                   full_screen = TRUE,
                   card_body(
                     tags$div(id="histDiv", 
                       mod_histogram_popup_ui("histogram_popup_1")))))),
              # Engagement
                nav_panel(
                  title = "Engagement"
                ),
              # Concepts
                nav_panel(
                  title = "Concepts"
                )
          # Close side bar  
          )),
          # ESRI Map
          tags$div(class="spinner"),
          tags$div(id="viewDiv"),
          # Attribute table
          tags$div(id="tableDiv"),
          
          # Extraction controls
          tags$div(id="extractPanel",
            card( 
              max_height = 800,
              full_screen = FALSE,
              card_header(
                prompter::add_prompt(
                  span("Zonal Statistics ", bs_icon("info-circle")),
                  message= "Extract impact metrics to polygons.", position = "right")
              ),
              card_body(
                fluidRow(column(12, 
                prompter::add_prompt(
                  span("Upload shapefile polygon files (.shp, .shx, .dbf and .prj)", bs_icon("info-circle")),
                  message = "Polygon displays proceeding successful upload."))),
                fluidRow(
                  column(10, mod_upload_data_ui("upload_data_1")),
                  column(2, mod_clear_data_ui("clear_data_1"))
                  ),
                fluidRow(class="user-fields",
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
