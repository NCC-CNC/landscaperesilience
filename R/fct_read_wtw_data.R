#' read_wtw_data 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export

read_wtw_data <- function(wtw_path) {
  
  # Read-in normalized variables, file paths
  lr_ready <- list.files(
    path = file.path(wtw_path, "resilience", "LR_READY"), 
    pattern = ".tif$", 
    full.names = TRUE
  )
  
  # Read-in raw variables, file paths
  lr_raw <- list.files(
    path = file.path(wtw_path, "resilience", "LR_RAW"),
    pattern = ".tif$", 
    full.names = TRUE
  )  
  
  # Read-in variables as terra::rast
  lr_ready <- lapply(lr_ready, rast)
  lr_raw <- lapply(lr_raw, rast)
  
  # Get Landscape Resilience
  landr <-rast(file.path(wtw_path, "resilience", "LandR.tif"))
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
       forest = list(layer=lr_ready[[10]], shp_name="nFOREST",   fun="sum", name="Common Species Goal"),
        grass = list(layer=lr_ready[[11]], shp_name="nGRASS",    fun="sum", name="Grassland"),
          hfi = list(layer=lr_ready[[12]], shp_name="nHFI",      fun="sum", name="Human Footprint Index"),
        river = list(layer=lr_ready[[13]], shp_name="nRIVER",    fun="sum", name="River"),
     sar_goal = list(layer=lr_ready[[14]], shp_name="nSAR_GOAL", fun="sum", name="Species at Risk Goal"),
     sar_rich = list(layer=lr_ready[[15]], shp_name="nSAR_RICH", fun="sum", name="Species at Risk Richness"),
        shore = list(layer=lr_ready[[16]], shp_name="nSHORE",    fun="sum", name="Shoreline"),
          wet = list(layer=lr_ready[[17]], shp_name="nWET",      fun="sum", name="Wetland")
    )
  
  lr_raw <- list(
    biod_rich = list(layer=lr_raw[[1]], shp_name="BIOD_RICH", fun="max", name="Common Species"),
     carbon_p = list(layer=lr_raw[[2]], shp_name="CARBON_P",  fun="sum", name="Carbon Potential"),
     carbon_s = list(layer=lr_raw[[3]], shp_name="CARBON_S",  fun="sum", name="Carbon Storage"),
    climate_c = list(layer=lr_raw[[4]], shp_name="CLIMATE_C", fun="sum", name="Climate Centrality"),
    climate_e = list(layer=lr_raw[[5]], shp_name="CLIMATE_E", fun="sum", name="Climate Extremes"),
    climate_r = list(layer=lr_raw[[6]], shp_name="CLIMATE_R", fun="sum", name="Climate Refugia"),
      connect = list(layer=lr_raw[[7]], shp_name="CONNECT",   fun="sum", name="Connectivity"),
     end_rich = list(layer=lr_raw[[8]], shp_name="END_RICH",  fun="max", name="Endemic Richness"),
       forest = list(layer=lr_raw[[9]], shp_name="FOREST",    fun="sum", name="Forest"),
       freshw = list(layer=lr_raw[[10]], shp_name="FRESHW",   fun="sum", name="Freshwater Provision"),
        grass = list(layer=lr_raw[[11]], shp_name="GRASS",    fun="sum", name="Grassland"),
          hfi = list(layer=lr_raw[[12]], shp_name="HFI",      fun="sum", name="Human Footprint"),
        lakes = list(layer=lr_raw[[13]], shp_name="LAKES",    fun="sum", name="Lakes"),
        parks = list(layer=lr_raw[[14]], shp_name="PARKS",    fun="sum", name="Protected Areas"),
          rec = list(layer=lr_raw[[15]], shp_name="REC",      fun="sum", name="Recreation"),
        river = list(layer=lr_raw[[16]], shp_name="RIVER",    fun="sum", name="River"),
     sar_rich = list(layer=lr_raw[[17]], shp_name="SAR_RICH", fun="max", name="Species at Risk"),
        shore = list(layer=lr_raw[[18]], shp_name="SHORE",    fun="sum", name="Shoreline"),
          wet = list(layer=lr_raw[[19]], shp_name="WET",      fun="sum", name="Wetland")
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
