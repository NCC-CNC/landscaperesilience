#' extract data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_extract_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    tagList(
      actionButton(inputId = ns("extract_data"), label = "Extract Data", width = "100%")
    )
  )
}
    
#' extract data Server Functions
#'
#' @noRd 
mod_extract_data_server <- function(id, user_poly, wtw_path, shp_name_field) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # Return
    to_return <- reactiveValues(
      user_poly_download = NULL, 
      user_poly_display = NULL,
      landr_tbl = NULL,
      completed_run = NULL
      )
    
    # Listen for run extraction button to be clicked
    observeEvent(input$extract_data, {
      
      #Start progress bar
      withProgress(
        message = "Running extractions",
        value = 0, max = 4, { incProgress(1)
                     
         tryCatch({ 
           
           
           # Load wtw data only once
           if (input$extract_data == 1) {
             id_ <- showNotification("... loading data", duration = 0, closeButton=close)
             input_data <<- read_wtw_data(wtw_path) # fct_read_wtw_data.R
             removeNotification(id_)
           }
           
           # Project to Canada_Albers_WGS_1984
           if (st_crs(user_poly) != st_crs(input_data$landr$layer)) {
             user_poly_prj <- st_transform(user_poly(), crs= st_crs(input_data$landr$layer))
           }
           
           # Create ObjectId
           user_poly_prj <- mutate(user_poly_prj, "OID" = row_number())
           
           # Calculate geometry ha
           user_poly_prj$AREA_HA <- units::drop_units(units::set_units(st_area(user_poly_prj), value = ha)) %>% round(2)
           
           # Message
           incProgress(2)
           id_ <- showNotification("Extracting impact metrics ...", duration = 0, closeButton=close)
           
           ## Extract MAX
           max_vars <- rlist::list.filter(input_data,(fun == "max"))
           max_layers <- rlist::list.mapv(max_vars, layer)
           max_shp_name <- rlist::list.mapv(max_vars, shp_name)
           extracted_max <- exact_extract(rast(max_layers), user_poly_prj, fun = "max", force_df = TRUE) %>% round(2)
           names(extracted_max) <- gsub("max.", "", max_shp_name)
           extracted_max[is.na(extracted_max)] <- 0 # replace NA with 0 
           
           ## Extract SUM
           sum_vars <- rlist::list.filter(input_data,(fun == "sum"))
           sum_layers <- rlist::list.mapv(sum_vars, layer)
           sum_shp_name <- rlist::list.mapv(sum_vars, shp_name)
           extracted_sum <- exact_extract(rast(sum_layers), user_poly_prj, fun = "sum", force_df = TRUE) %>% round(2)
           names(extracted_sum) <- gsub("sum.", "", sum_shp_name)
           extracted_sum[is.na(extracted_sum)] <- 0 # replace NA with 0   
           
           ## Extract Landscape Resilience distribution
           # Message
           incProgress(3)
           removeNotification(id_)
           id_ <- showNotification("Extracting resilience ...", duration = 0, closeButton=close)
           
           user_poly_prj$LANDR_SUM <- exact_extract(input_data$landr$layer, user_poly_prj, 'sum') %>% round(2)
           user_poly_prj$LANDR_MIN <- exact_extract(input_data$landr$layer, user_poly_prj, 'min') %>% round(2)
           user_poly_prj$LANDR_MU <- exact_extract(input_data$landr$layer, user_poly_prj, 'mean') %>% round(2)
           user_poly_prj$LANDR_MED <- exact_extract(input_data$landr$layer, user_poly_prj, 'median') %>% round(2)
           user_poly_prj$LANDR_MAX <- exact_extract(input_data$landr$layer, user_poly_prj, 'max') %>% round(2)
           user_poly_prj$LANDR_SD <- exact_extract(input_data$landr$layer, user_poly_prj, 'stdev') %>% round(2)
           landr_tbl <- exact_extract(input_data$landr$layer, user_poly_prj) 
           
           # Round all values
           landr_tbl <-round_nested_list(landr_tbl) # fct_round_nested_list.R
          
           # Combine extractions into on sf object
           user_poly_prj <- cbind(user_poly_prj, extracted_max, extracted_sum)
           
           # Project to WGS
           user_poly_wgs <- st_transform(user_poly_prj, crs=4326)
           
           # Populate return objects
           to_return$completed_run <- input$extract_data
           to_return$user_poly_download <- user_poly_prj
           to_return$user_poly_display <- user_poly_wgs
           to_return$landr_tbl <- landr_tbl
           
           # Send to client
           send_geojson(
             session, 
             user_poly = user_poly_wgs,
             poly_id = "data_poly", 
             poly_title = "Upload Polygon (Data)",
             shp_name_field = shp_name_field()
            )
           
           # enable metrics picker in card
           shinyjs::enable("metrics_bar_1-impact", asis = TRUE)
           
           # Finish progress bar
           incProgress(4)
           removeNotification(id_)
           showNotification("... Extractions Completed!", duration = 5, closeButton=TRUE, type = 'message')           
           
         # Close try
         },
                     
         # Show error message
         error = function(err){
           removeNotification(id_)
           showNotification("ERROR!", type = 'err', duration = 5, closeButton=close)
           showNotification(paste0(err), type = 'err', duration = 5, closeButton=close)
         })
       # Close progress bar
       })
    # Close observeEvent
    })
    
    # Return extractions
    return(to_return)
    
 # Close module     
 })
# Close server  
}
    
## To be copied in the UI
# mod_extract_ui("extract_data_1")
    
## To be copied in the server
# mod_extract_server("extract_data_1")
