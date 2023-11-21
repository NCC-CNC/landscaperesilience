#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  add_resource_path("www", app_sys("app/www"))
  tagList(
    # Your application UI logic
    fluidPage(
      tags$head(
        tags$link(rel="stylesheet", href="https://js.arcgis.com/4.28/esri/themes/light/main.css"),
        tags$script(src="https://js.arcgis.com/4.28/"),
      tags$script(type="module", src="www/main.js", defer=""),
        tags$link(rel="stylesheet", type="text/css", href="www/styles.css"),
      ),
      
      h1("landscaperesilience"),
      tags$div(id = "viewDiv")
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
