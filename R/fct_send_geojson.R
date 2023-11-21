#' send_geojson 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
send_geojson <- function(session, user_poly) {
  
  # call reactive
  user_poly <- user_poly()

  # translate to WGS 84
  if (st_crs(user_poly) != st_crs(4326)) {
    user_poly <- st_transform(user_poly, crs=4326)
  }
  
  # translate to geojson
  geojson <- sf_geojson(user_poly)
  
  # send geojson to client
  session$sendCustomMessage(
    type = "send-geojson", message = geojson
  )
  
}