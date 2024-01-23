#' metrics_bar 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#' 

empty_metrics_bar <- function() {
  # Build bar chart
  bar_chart <- highcharter::highchart() %>%
    highcharter::hc_add_series(data = NULL, type="bar") %>%
    highcharter::hc_yAxis(title = list(text = "Impact Metrics")) %>%
    highcharter::hc_xAxis(title = list(text = "Polygons")) %>%
    highcharter::hc_subtitle(text = "No Data") %>%
    highcharter::hc_legend(enabled = FALSE) %>%
    highcharter::hc_tooltip(
      formatter = htmlwidgets::JS(
        "function() { return this.x + '<br>' + this.y.toLocaleString(); }"
      )) 
  return(bar_chart)
}
