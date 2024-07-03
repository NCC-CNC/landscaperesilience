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
      actionButton(inputId = ns("extract_data"), label = "Run", icon=icon("play"), width = "100%")
    )
  )
}
    
#' extract data Server Functions
#'
#' @noRd 
mod_extract_data_server <- function(id, user_poly, nat_1km, shp_name_field, tif_data = NULL, shp_name) {
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
        value = 0, max = 5, { incProgress(1)
                     
         tryCatch({ 
           
           ## add map spinner
           shinyjs::runjs(
             "const spinner = document.querySelector('.spinner');
              spinner.style.display = 'block'"
           )
           
           # Load wtw data only once
           if (input$extract_data == 1) {
             id_ <- showNotification("... loading data", duration = 0, closeButton=close)
             input_data <<- read_nat_1km(nat_1km) # fct_read_nat_1km.R
             removeNotification(id_)
           }
           
           # Validate shp and drop M & Z values
           user_poly_valid <- shp_valid(user_poly()) # fct_shp_valid
           
           # Project to Canada_Albers_WGS_1984
           if (st_crs(user_poly) != st_crs(input_data$landr)) {
             user_poly_prj <- st_transform(user_poly_valid, crs= st_crs(input_data$landr))
           }
           
           # Create ObjectId
           user_poly_prj <- mutate(user_poly_prj, "OID" = row_number())
           
           # Calculate geometry ha
           user_poly_prj$AREA_HA <- units::drop_units(units::set_units(st_area(user_poly_prj), value = ha)) %>% round(2)
           
           # Message
           incProgress(2)
           id_ <- showNotification("Extracting impact metrics ...", duration = 0, closeButton=close)
           
           ## Extract normalized variables (lr_ready), sum
           lr_ready_layers <- rlist::list.mapv(input_data$lr_ready, layer)
           lr_ready_shp_name <- rlist::list.mapv(input_data$lr_ready, shp_name)
           extracted_lr_ready <- exact_extract(rast(lr_ready_layers), user_poly_prj, fun = "sum", force_df = TRUE) %>% round(2)
           names(extracted_lr_ready) <- gsub("sum.", "", lr_ready_shp_name)
           extracted_lr_ready[is.na(extracted_lr_ready)] <- 0 # replace NA with 0 
           
           ## Extract raw variables, sum
           sum_vars <- rlist::list.filter(input_data$lr_raw,(fun == "sum"))
           sum_layers <- rlist::list.mapv(sum_vars, layer)
           sum_shp_name <- rlist::list.mapv(sum_vars, shp_name)
           extracted_sum <- exact_extract(rast(sum_layers), user_poly_prj, fun = "sum", force_df = TRUE) %>% round(2)
           names(extracted_sum) <- gsub("sum.", "", sum_shp_name)
           extracted_sum[is.na(extracted_sum)] <- 0 # replace NA with 0 
           
           ## Extract raw variables, max
           max_vars <- rlist::list.filter(input_data$lr_raw,(fun == "max"))
           max_layers <- rlist::list.mapv(max_vars, layer)
           max_shp_name <- rlist::list.mapv(max_vars, shp_name)
           extracted_max <- exact_extract(rast(max_layers), user_poly_prj, fun = "max", force_df = TRUE) %>% round(2)
           names(extracted_max) <- gsub("max.", "", max_shp_name)
           extracted_max[is.na(extracted_max)] <- 0 # replace NA with 0             
           
           ## Extract Landscape Resilience distribution
           incProgress(3)
           removeNotification(id_)
           id_ <- showNotification("Extracting resilience ...", duration = 0, closeButton=close)
           landr_tbl <- exact_extract(input_data$landr, user_poly_prj) 
           landr_tbl <-round_nested_list(landr_tbl) # fct_round_nested_list.R
           
           ## Calculate Landscape Resilience on the fly
           extracted_lr_ready <- extracted_lr_ready  %>%
             mutate(
               LANDR_POS =
                 nCH +
                 nBIOD_GOAL + nEND_GOAL + nSAR_GOAL + 
                 nBIOD_RICH + nEND_RICH + nSAR_RICH +
                 nCLIMATE_C + nCLIMATE_R +
                 nCONNECT +
                 nFOREST_LC + nGRASS + nWET + nSHORE + nRIVER
             ) %>%
             mutate(LANDR_NEG = nCLIMATE_E + nHFI) %>%
             mutate(LANDR_ABS = LANDR_POS + LANDR_NEG) %>%
             mutate(LANDR = LANDR_POS - LANDR_NEG, .before=1)
           
           ## Calculate contribution %
           extracted_lr_ready <- extracted_lr_ready %>%
             mutate(pCH = (nCH / LANDR_ABS) * 100) %>%
             mutate(pBIOD_GOAL = (nBIOD_GOAL / LANDR_ABS) * 100) %>%
             mutate(pEND_GOAL = (nEND_GOAL / LANDR_ABS) * 100) %>%
             mutate(pSAR_GOAL = (nSAR_GOAL / LANDR_ABS) * 100) %>%
             mutate(pBIOD_RICH = (nBIOD_RICH / LANDR_ABS) * 100) %>%
             mutate(pEND_RICH = (nEND_RICH / LANDR_ABS) * 100) %>%
             mutate(pSAR_RICH = (nSAR_RICH / LANDR_ABS) * 100) %>%
             mutate(pCLIMATE_C = (nCLIMATE_C / LANDR_ABS) * 100) %>%
             mutate(pCLIMATE_R = (nCLIMATE_R / LANDR_ABS) * 100) %>%
             mutate(pCONNECT = (nCONNECT / LANDR_ABS) * 100) %>%
             mutate(pFOREST_LC = (nFOREST_LC / LANDR_ABS) * 100) %>%
             mutate(pGRASS = (nGRASS / LANDR_ABS) * 100) %>%
             mutate(pWET = (nWET / LANDR_ABS) * 100) %>%
             mutate(pSHORE = (nSHORE / LANDR_ABS) * 100) %>%
             mutate(pRIVER = (nRIVER / LANDR_ABS) * 100) %>%
             mutate(pCLIMATE_E = (nCLIMATE_E / LANDR_ABS) * 100) %>%
             mutate(pHFI = (nHFI / LANDR_ABS) * 100) %>%
             mutate(across(where(is.numeric), round, digits = 2))
          
           # Extract user .tif(s)
           incProgress(4)
           removeNotification(id_)
           id_ <- showNotification("Extracting .tifs ...", duration = 0, closeButton=close)
           
           if (length(tif_data$ids) > 0) {
             for (i in 1:length(tif_data$ids)){
               tif <- tif_data$layers[[i]]
               if (isTruthy(tif)) {
                 # validate field name
                 field_name <- shp_field_valid(tif_data$names[[i]]) # fct_shp_field_valid.R
                 field_name <- ifelse(is.na(field_name), paste0("TIF_", i), field_name)
                 # get stat
                 stat <- tif_data$stats[[i]]
                 # extract
                 user_poly_prj[[field_name]] <- exact_extract(tif, user_poly_prj, stat) %>% round(2)
               }
             }
           }
           
           # Combine extractions into one sf object, calculate adjusted LandR
           user_poly_prj <- cbind(user_poly_prj, extracted_max, extracted_sum, extracted_lr_ready) %>%
             relocate(LANDR, .after = AREA_HA) %>%
             mutate(adjLANDR = round(LANDR / AREA_HA, 4), .after = LANDR)
           
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
             poly_title = shp_name(),
             shp_name_field = shp_name_field()
            )
           
           # Enable metrics picker in card
           shinyjs::enable("metrics_bar_1-impact", asis = TRUE)

           # Finish progress bar
           incProgress(5)
           removeNotification(id_)
           showNotification("... Extractions Completed!", duration = 5, closeButton=TRUE, type = 'message')           
           
         # Close try
         },
                     
         # Show error message
         error = function(err){
           removeNotification(id_)
           showNotification("ERROR!", type = 'err', duration = 5, closeButton=close)
           showNotification(paste0(err), type = 'err', duration = 5, closeButton=close)
           ## remove map spinner
           shinyjs::runjs(
             "const spinner = document.querySelector('.spinner');
              spinner.style.display = 'none'"
           )           
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
