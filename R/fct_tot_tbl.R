#' tot_tbl 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export

tot_tbl <- function(sf) {
  tbl <- sf %>%
    st_drop_geometry() %>%
    summarise(
      `Area (ha)` = sum(AREA_HA), n = n(),
      `Forest (ha)` = sum(FOREST), n = n(),
      `Wetland (ha)` = sum(WET), n = n(),
      `Grassland (ha)` = sum(GRASS), n = n(),
      `Lakes (ha)` = sum(LAKES), n = n(),
      `Rivers (km)` = sum(RIVER), n = n(),
      `Shoreline (km)` = sum(SHORE), n = n(),
      `Carbon Storage (t)` = sum(CARBON_S), n = n(),
      `Carbon Potential (t/yr)` = sum(CARBON_P), n = n()
    ) %>%
    relocate(n, .before = 1) %>%
    tidyr::pivot_longer(cols = everything()) %>%
    rename("Metric" = name) %>%
    rename("Total" = value)
}