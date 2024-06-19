#' shp_valid 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
shp_valid <- function(x) {
  if (!all(st_is_valid(x))) {
    x <- st_make_valid(x)
  }
  x <- st_zm(x) # drop x and z values
}