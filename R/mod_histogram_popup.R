#' histogram_popup UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_histogram_popup_ui <- function(id){
  ns <- NS(id)
  tagList(
    highcharter::highchartOutput(outputId = ns("histpopup"), height = "325px")
  )
}
    
#' histogram_popup Server Functions
#'
#' @noRd 
mod_histogram_popup_server <- function(id, landr_tbl, oid = NULL, user_poly = NULL, shp_name= NULL){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    if (is.null(oid)) {
      
      # build empty histogram df
      landr_hist_bits <- landr_hist_bits(landr_tbl=NULL, oid=NULL)
      landr_df <- landr_hist_bits[[1]] 
      
      # render empty histogram
      h <- empty_landr_hist(landr_df)
      output$histpopup <- highcharter::renderHighchart({ h })
      
      } else {
      
      # extract name    
      name <- user_poly() %>%
        st_drop_geometry() %>%
        filter(OID == oid) %>%
        pull(shp_name())
      
      # build landR histogram df
      landr_hist_bits <- landr_hist_bits(landr_tbl=landr_tbl, oid=oid)
      landr_df <- landr_hist_bits[[1]]
      landr_mean <- landr_hist_bits[[2]]
      bins <- landr_hist_bits[[3]]
      
      # Update histogram  
      highcharter::highchartProxy("histogram_popup_1-histpopup") %>%
        highcharter::hcpxy_remove_series(all=TRUE) %>%
        highcharter::hcpxy_add_series(
          type= "column",
          data = landr_df,
          pointPadding = 0, groupPadding = 0, borderWidth = 0, pointWidth = 10,
          color = "#33862B",
          mapping = highcharter::hcaes(x = Xlabel, y = Count)
          ) %>%
        highcharter::hcpxy_update(
          subtitle = list(text = name),
          xAxis = list(
            plotLines = list(list(
              value = findInterval(landr_mean, bins) - 1,
              color = '#FF5B00',
              width = 1,
              zIndex = 4,
              label = list(
                text = paste0("mean: ", landr_mean),
                style = list( color = '#FF5B00', fontWeight = 'bold')))))
        ) 
      }
  })
}
    
## To be copied in the UI
# mod_histogram_popup_ui("histogram_popup_1")
    
## To be copied in the server
# mod_histogram_popup_server("histogram_popup_1")
