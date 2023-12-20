#' send_geojson 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
send_geojson <- function(session, user_poly, poly_id, poly_title, shp_name_field=NULL, raster_name_fields = NULL) {
  
  # call reactive if a reactive object
  if (inherits(user_poly, "reactive")) {
    user_poly <- user_poly()    
  }

  # translate to WGS 84
  if (st_crs(user_poly) != st_crs(4326)) {
    user_poly <- st_transform(user_poly, crs=4326)
  }
  
  # translate to geojson
  geojson <- sf_geojson(user_poly)
  
  # send geojson to client
  session$sendCustomMessage(
    type = "send-geojson", message = list(poly_id, poly_title, geojson, shp_name_field, raster_name_fields)
  )
  
}