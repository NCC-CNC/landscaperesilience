#' upload_rasters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_upload_rasters_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(2,
      actionButton(inputId = ns("add_raster_btn"), label = NULL,  icon=icon("add"), width = "100%")),
      column(10, class = "add_raster_p",
      tooltip(
        span("Add regional .tifs to be included (optional)",  bs_icon("info-circle")),
        "Experimental feature.", placement = "top")
      )),
    fluidRow(column(12, id="rasterDiv")))
}
    
#' upload_rasters Server Functions
#'
#' @noRd 
mod_upload_rasters_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Return
    tif_data <-  reactiveValues(
      ids = list(), 
      layers = list(),
      names = list(),
      stats = list()
      )
    
    observeEvent(input$add_raster_btn, {
      
      # populate tif data list
      tif_id <- input$add_raster_btn
      tif_data$ids <- append(tif_data$ids, tif_id)
      tif_data$layers <- append(tif_data$layers, NA)
      tif_data$names <- append(tif_data$names, NA_character_)
      tif_data$stats <- append(tif_data$stats, "sum")
      
      # build div to insert
      div <- tags$div(
        id = paste0("add_raster_control_", input$add_raster_btn), 
        class = "add_raster_control",
        br(),
        fluidRow(
          column(7,
          tooltip(
          fileInput(
            inputId = ns(paste0("tif_", tif_id)), 
            label = NULL, 
            multiple = FALSE,
            accept = ".tif",
            width = "100%"),
          "Upload a prepped .tif raster")),
          column(4,
          tooltip(
          textInput(
            inputId = ns(paste0("tif_name_", tif_id)), 
            label = NULL, 
            placeholder = "[NAME]", 
            value = NULL, 
            width = "100%"),
          "Provide short name", placement = "top")),
          column(1, class = "remove-raster-btn",
          tooltip(       
          actionButton(
            inputId = ns(paste0("remove_tif_", tif_id)), 
            icon = icon("ban"),  
            label = NULL, 
            width = "100%"),
          "Clear data", placement = "top"))
          ),
        fluidRow(
          column(7),
          column(5, class="stats",
         tooltip(         
         radioButtons(
           inputId = ns(paste0("tif_stat_", tif_id)), 
           label = NULL, choices = c("sum","max"), 
           inline = TRUE),
         "Select statistic", placement = "left")))
        )
      
      # insert div
      insertUI(
        selector = "#rasterDiv",
        where = "afterEnd",
        ui = div
        )
    })
  
    
   # add raster tif   
   observeEvent( 
     lapply(tif_data$ids, function(x) { input[[paste0("tif_", x)]] }), {
       if(isTruthy(tif_data$ids)) {
         for(x in tif_data$ids) {
           if(isTruthy(input[[paste0("tif_", x)]]$datapath) &&
              is.null(tif_data$raster_layer[[x]][1])
             ){
             # add raster
             tif_data$layers[[x]] <- rast(input[[paste0("tif_", x)]]$datapath)
           }
         }
       }
   })
   
   # add raster tif name   
   observeEvent( 
     lapply(tif_data$ids , function(x) { input[[paste0("tif_name_", x)]] }), {
       if(isTruthy(tif_data$ids)) {
         for(x in tif_data$ids) {
           if(isTruthy(input[[paste0("tif_name_", x)]])){
             
             # tif name validation
             invalid_symbols <- "!@#$%^&*()-+=[]{}|\\:;\'\"<>,.?~"
             iv <- shinyvalidate::InputValidator$new()
             iv$add_rule(
               inputId = paste0("tif_name_", x), 
               rule = function(value) {
                 if (nchar(value) > 9) {
                   "9 char limit"
                 } else if (grepl("^\\d", value)) {
                   "numeric start"
                 } else if (value %in% c("ID", "OID", "SHAPE")) {
                   "reserved word"
                 } else if(grepl(paste0("[", gsub("([][|\\\\])", "\\\\\\1", invalid_symbols), "]"), value, perl = TRUE)) {
                   "invalid chars" 
                 } else if (grepl(" ", value)) {
                   "no spaces"
                 }
               }
              )
             iv$enable()
             
             # add raster name
             tif_data$names[[x]] <- input[[paste0("tif_name_", x)]]
           }
         }
       }
     })
   
   # add tif stat   
   observeEvent( 
     lapply(tif_data$ids , function(x) { input[[paste0("tif_stat_", x)]] }), {
       if(isTruthy(tif_data$ids)) {
         for(x in tif_data$ids) {
           if(isTruthy(input[[paste0("tif_stat_", x)]])){
            # add tiff stat
            tif_data$stats[[x]] <- input[[paste0("tif_stat_", x)]]
           }
          }
        }
     })
   
   # remove raster tif
   observeEvent( 
     lapply(tif_data$ids , function(x) { input[[paste0("remove_tif_", x)]] }), {
       if(isTruthy(tif_data$ids)) {
         for(x in tif_data$ids) {
           if (isTruthy(input[[paste0("remove_tif_", x)]])) {
             removeUI(selector = paste0("#add_raster_control_", x))
             # clear id
             tif_data$ids[[x]][1] <- NA_integer_
             # clear raster
             tif_data$layers[[x]] <- NA
             # clear name
             tif_data$names[[x]][1] <- NA_character_
             # clear stat
             tif_data$stats[[x]][1] <- NA_character_
           }
         }
       }
    })
   
   # Return tif data
   return(tif_data)
  })
}
    
## To be copied in the UI
# mod_upload_rasters_ui("upload_rasters_1")
    
## To be copied in the server
# mod_upload_rasters_server("upload_rasters_1")
