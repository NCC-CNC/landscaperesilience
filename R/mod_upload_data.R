#' upload_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_upload_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    tooltip(
    fileInput(
      inputId = ns("upload_data"), 
      label = tooltip(
        trigger = list(
          "Upload shapefile polygon",
          bs_icon("info-circle")
        ),
        "The polygon displays proceeding successful upload",
        placement = "top"
      ), 
      multiple = TRUE,
      accept = c(".shp", ".shx", ".dbf", ".prj", ".sbn", ".sbx", ".cpg"),
      width = "100%"),
    ".shp, .shx, .dbf and .prj files are required.")
  )
}
    
#' upload_data Server Functions
#'
#' @noRd 
mod_upload_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # reactive values to return
    to_return <- reactiveValues(user_poly=NULL, fields=NULL, path=NULL, shp_name=NULL)
    path <- reactive({input$upload_data})
    shp <- read_shp(path) # fct_read_upload.R 
    fields <- reactive({ 
      # filter for numeric or character fields only
      colnames(shp())[sapply(shp(), function(col) is.numeric(col) || is.character(col))] 
      })
    
    observeEvent(path(), {
      
      # validate
      if (is.null(shp())) {
        shinyjs::runjs(
          '
          $("#upload_data_1-upload_data_progress").css("background-color", "#cb181d");
          $("#upload_data_1-upload_data_progress").text("Upload Error: Clear input and try again.");
          $("#upload_data_1-upload_data_progress").css("color", "#fff");
          $("#upload_data_1-upload_data_progress").css("display", "flex");
          $("#upload_data_1-upload_data_progress").css("justify-content", "center");
          const spinner = document.querySelector(".spinner");
          spinner.style.display = "none";
          ' 
        )
        shinyjs::disable("upload_data_1-upload_data", asis = TRUE)
      } else {
        shinyjs::runjs(
          '
          $("#upload_data_1-upload_data_progress").css("background-color", "#33862B");
          $("#upload_data_1-upload_data_progress").text("Upload Success");
          $("#upload_data_1-upload_data_progress").css("color", "#fff");
          $("#upload_data_1-upload_data_progress").css("display", "flex");
          $("#upload_data_1-upload_data_progress").css("justify-content", "center");
          ' 
        )
      }
      
      # get shp name with extension
      shp_name <- reactive({ path()$name[grepl("\\.shp$", path()$name)] })
      
      # map: send upload to client
      send_geojson(session=session, user_poly=shp, poly_id="upload_poly", poly_title=shp_name())
      
      # return for extractions
      to_return$user_poly <- shp()
      to_return$fields <- fields()
      to_return$path <- path()
      to_return$shp_name <- shp_name()

      # enable extraction button
      if (isTruthy(shp())) {
        shinyjs::enable("name_from_user_poly_1-PN", asis= TRUE)
        shinyjs::enable("extract_data_1-extract_data", asis = TRUE)
        shinyjs::disable("upload_data_1-upload_data", asis = TRUE)
      }
      
    })
    return(to_return)
  })
}
    
## To be copied in the UI
# mod_upload_data_ui("upload_data_1")
    
## To be copied in the server
# mod_upload_data_server("upload_data_1")
