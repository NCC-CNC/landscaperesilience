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
      p("add .tif (optional)"))),
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
          fileInput(
            inputId = ns(paste0("tif_", tif_id)), 
            label = NULL, 
            multiple = FALSE)),
          column(3,
          textInput(
            inputId = ns(paste0("tif_name_", tif_id)), 
            label = NULL, 
            placeholder = "[NAME]", 
            value = NULL, 
            width = "100%")),
          column(2, class = "remove-raster-btn",
          actionButton(
            inputId = ns(paste0("remove_tif_", tif_id)), 
            icon = icon("ban"),  
            label = NULL, 
            width = "100%"))
          ),
        fluidRow(
          column(7),
          column(5, class="stats", 
         radioButtons(
           inputId = ns(paste0("tif_stat_", tif_id)), 
           label = NULL, choices = c("sum","max"), 
           inline = TRUE)))
        )
      
      # insert div
      insertUI(
        selector = "#rasterDiv",
        where = "afterEnd",
        ui = div
        )
      
      # disable add raster btn
      shinyjs::disable("upload_rasters_1-add_raster_btn", asis = TRUE)
      
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
             # enable add button
             if (isTruthy(tif_data$layers[[x]]) && isTruthy(tif_data$names[[x]])) {
               shinyjs::enable("upload_rasters_1-add_raster_btn", asis = TRUE)
             } 
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
             # add raster name
             tif_data$names[[x]] <- input[[paste0("tif_name_", x)]]
             # enable add button
             if (isTruthy(tif_data$layers[[x]]) && isTruthy(tif_data$names[[x]])) {
               shinyjs::enable("upload_rasters_1-add_raster_btn", asis = TRUE)
             } 
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
             # enable add button
             shinyjs::enable("upload_rasters_1-add_raster_btn", asis = TRUE)
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
