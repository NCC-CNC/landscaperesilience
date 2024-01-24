#' landr_hist_bits
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#' 

landr_hist_bits <- function(landr_tbl=NULL, oid=NULL) {
  
  if(is.null(landr_tbl)) {
    # get lanrR values, dummy data
    landr_values <- runif(15, min = 0, max = 3) %>% round(2)
  } else {
    # get landR values
    landr_values <- unname(unlist(landr_tbl[[oid]][1]))
  }
  
  # get mean value
  mean_value <- mean(landr_values) %>% round(2)
  
  # build histogram table info
  bins <- seq(0, 3.8, by = 0.2) 
  bin_counts <- cut(landr_values, bins, right = FALSE) 
  df <- data.frame(table(bin_counts))
  df$Bins <- as.character(df$bin_counts)
  df$Count <- df$Freq
  # Generate labels for the bins
  df$Xlabel <- gsub(",", "-", substring(as.character(df$Bins), 2, nchar(as.character(df$Bins)) - 1))
  
  return(list(df, mean_value, bins))
}


#' empty_landr_hist
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#' 
empty_landr_hist <- function(landr_hist_df) {

  # build bar chart disguised as a histogram. Include chart elements for proxy. 
  bar_chart <- highcharter::highchart() %>%
    highcharter::hc_chart(type = "column") %>%
    highcharter::hc_add_series(
      data = NULL, # <- this makes the chart empty
      pointPadding = 0, groupPadding = 0, borderWidth = 0, pointWidth = 10,
      color = "#33862B") %>%
    highcharter::hc_xAxis(
      title = list(text = "Resilience Scores Distribution (neighbourhood)"),
      categories = landr_hist_df$Xlabel,
      tickWidth = 1,     
      tickColor = "#000"
      ) %>%
    highcharter::hc_subtitle(text = "No Data") %>%
    highcharter::hc_yAxis(
      title = list(text = "Area (km2)")) %>%
    highcharter::hc_tooltip(
      formatter = htmlwidgets::JS(
        "function() { return 'Score Range: ' + this.x + '<br>Area (km2): ' + this.y; }"
        )) %>%
    highcharter::hc_legend(enabled = FALSE)
  
  return(bar_chart)
}
