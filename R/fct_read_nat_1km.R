#' read_nat_1km
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export

read_nat_1km <- function(nat_1km) {
  
  # Get NAT_1KM files
  nat_1km_tifs <- list.files(
    path = file.path(nat_1km),
    pattern = ".tif$", 
    full.names = TRUE,
    recursive = TRUE
  ) 
  
  # Subset for all normalized layers
  lr_ready <- grep("norm", nat_1km_tifs, value = TRUE)
  # Subset for raw layers
  lr_raw <- grep("norm|goals|_1km|cons.tif|d2_cons|kba|landr", nat_1km_tifs, invert = TRUE, value = TRUE)
  
  # Read-in variables as terra::rast
  lr_ready <- lapply(lr_ready, rast)
  lr_raw <- lapply(lr_raw, rast)
  
  # Get Landscape Resilience
  landr <-rast(file.path(nat_1km, "landr", "landr.tif"))
  names(landr) <- "LANDR"
    
  # Create named list
  lr_ready <- list(
    biod_goal = list(layer=lr_ready[[1]], shp_name="nBIOD_GOAL", fun="sum", name="Common Species Goal"),
    biod_rich = list(layer=lr_ready[[2]], shp_name="nBIOD_RICH", fun="sum", name="Common Species Richness"),
           ch = list(layer=lr_ready[[3]], shp_name="nCH",        fun="sum", name="Critical Habitat"),
    climate_c = list(layer=lr_ready[[4]], shp_name="nCLIMATE_C", fun="sum", name="Climate Centrality"),
    climate_e = list(layer=lr_ready[[5]], shp_name="nCLIMATE_E", fun="sum", name="Climate Extremes"),
    climate_r = list(layer=lr_ready[[6]], shp_name="nCLIMATE_R", fun="sum", name="Climate Refugia"),
      connect = list(layer=lr_ready[[7]], shp_name="nCONNECT",   fun="sum", name="Connectivity"),
     end_goal = list(layer=lr_ready[[8]], shp_name="nEND_GOAL",  fun="sum", name="Endemic Goal"),
     end_rich = list(layer=lr_ready[[9]], shp_name="nEND_RICH",  fun="sum", name="Endemic Richness"),
    forest_lc = list(layer=lr_ready[[10]], shp_name="nFOREST_LC",fun="sum", name="Forest Landcover"),
        grass = list(layer=lr_ready[[11]], shp_name="nGRASS",    fun="sum", name="Grassland"),
          hfi = list(layer=lr_ready[[12]], shp_name="nHFI",      fun="sum", name="Human Footprint Index"),
        river = list(layer=lr_ready[[13]], shp_name="nRIVER",    fun="sum", name="River"),
     sar_goal = list(layer=lr_ready[[14]], shp_name="nSAR_GOAL", fun="sum", name="Species at Risk Goal"),
     sar_rich = list(layer=lr_ready[[15]], shp_name="nSAR_RICH", fun="sum", name="Species at Risk Richness"),
        shore = list(layer=lr_ready[[16]], shp_name="nSHORE",    fun="sum", name="Shoreline"),
          wet = list(layer=lr_ready[[17]], shp_name="nWET",      fun="sum", name="Wetland")
    )
  
  lr_raw <- list(
           ch = list(layer=lr_raw[[1]], shp_name="CH",        fun="sum", name="Critical Habitat"),
    biod_rich = list(layer=lr_raw[[2]], shp_name="BIOD_RICH", fun="max", name="Common Species"),
     end_rich = list(layer=lr_raw[[3]], shp_name="END_RICH",  fun="max", name="Endemic Richness"),
     sar_rich = list(layer=lr_raw[[4]], shp_name="SAR_RICH", fun="max", name="Species at Risk"),
     carbon_p = list(layer=lr_raw[[5]], shp_name="CARBON_P",  fun="sum", name="Carbon Potential"),
     carbon_s = list(layer=lr_raw[[6]], shp_name="CARBON_S",  fun="sum", name="Carbon Storage"),
    climate_c = list(layer=lr_raw[[7]], shp_name="CLIMATE_C", fun="sum", name="Climate Centrality"),
    climate_e = list(layer=lr_raw[[8]], shp_name="CLIMATE_E", fun="sum", name="Climate Extremes"),
    climate_r = list(layer=lr_raw[[9]], shp_name="CLIMATE_R", fun="sum", name="Climate Refugia"),
      connect = list(layer=lr_raw[[10]], shp_name="CONNECT",   fun="sum", name="Connectivity"),
        parks = list(layer=lr_raw[[11]], shp_name="PARKS",    fun="sum", name="Protected Areas"),
       freshw = list(layer=lr_raw[[12]], shp_name="FRESHW",   fun="sum", name="Freshwater Provision"),
          rec = list(layer=lr_raw[[13]], shp_name="REC",      fun="sum", name="Recreation"),
    forest_lc = list(layer=lr_raw[[14]], shp_name="FOREST_LC", fun="sum", name="Forest Landcover"),
    forest_lu = list(layer=lr_raw[[15]], shp_name="FOREST_LU", fun="sum", name="Forest Landuse"),
        grass = list(layer=lr_raw[[16]], shp_name="GRASS",    fun="sum", name="Grassland"),
        lakes = list(layer=lr_raw[[17]], shp_name="LAKES",    fun="sum", name="Lakes"),
        river = list(layer=lr_raw[[18]], shp_name="RIVER",    fun="sum", name="River"),
        shore = list(layer=lr_raw[[19]], shp_name="SHORE",    fun="sum", name="Shoreline"),
          wet = list(layer=lr_raw[[20]], shp_name="WET",      fun="sum", name="Wetland"),
          hfi = list(layer=lr_raw[[21]], shp_name="HFI",      fun="sum", name="Human Footprint")
    )
    
  # return
  return(
    list(
      lr_raw = lr_raw, 
      lr_ready = lr_ready, 
      landr = landr
      )
    )
}
