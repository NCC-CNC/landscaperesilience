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
  
  # Get Landscape Resilience Baselayer----
  landr <-rast(file.path(wtw_path, "resilience", "LandR.tif"))
  names(landr) <- "LANDR"
    
  # Get NCC PU
  pu <- rast(file.path(wtw_path, "nat_pu", "NCC_1KM_PU.tif"))
  pu[pu==1] <- 0
  
  # Get Biodiversity Data ----
  ## key biodiversity areas
  kba <- rast(file.path(wtw_path, "biodiversity", "KBA.tif"))
  names(kba) <-"KBA"
  
  ## critical habitat
  ch <- rast(file.path(wtw_path, "biodiversity", "ECCC_CH_ALL_HA_SUM.tif"))
  names(ch) <-"CH_ECCC"
  
  ## goals
  ### biodiversity species goal
  biod_goal <- rast(file.path(wtw_path, "biodiversity", "goals", "BOID_SUM_GOAL.tif"))
  names(biod_goal) <- "BIOD_GOAL"
  
  ### endemic species goal
  end_goal <- rast(file.path(wtw_path, "biodiversity", "goals", "NSC_END_SUM_GOAL.tif"))
  names(end_goal) <- "END_GOAL"
  
  ### species at risk goal
  sar_goal <- rast(file.path(wtw_path, "biodiversity", "goals", "ECCC_SAR_SUM_GOAL.tif"))
  names(sar_goal) <- "SAR_GOAL"
  
  ## richness
  ### biodiversity species richness
  biod_rich <- rast(file.path(wtw_path, "biodiversity", "richness", "BOID_COUNT.tif"))
  names(biod_rich) <- "BIOD_RICH"
  
  ### endemic species richness
  end_rich <- rast(file.path(wtw_path, "biodiversity", "richness", "NSC_END_COUNT.tif"))
  names(end_rich) <- "END_RICH"
  
  ### species at risk richness
  sar_rich <- rast(file.path(wtw_path, "biodiversity", "richness", "ECCC_SAR_COUNT.tif"))
  names(sar_rich) <- "SAR_RICH"
  
  # Get Carbon Data ----
  ## carbon storage
  carbon_s <- rast(file.path(wtw_path, "carbon", "Carbon_Mitchell_2021_t.tif"))
  names(carbon_s) <- "CARBON_S"
  
  ## carbon potential
  carbon_p <- rast(file.path(wtw_path, "carbon", "Carbon_Potential_NFI_2011_CO2e_t_year.tif"))
  names(carbon_p) <- "CARBON_P"
  
  # Get Connectivity Data ----
  ## connectivity
  connect <- rast(file.path(wtw_path, "connectivity", "Connectivity_Pither_Current_Density.tif"))
  names(connect) <- "CONNECT"
  
  # Get Climate Data ----
  ## centrality
  climate_c <- rast(file.path(wtw_path, "climate", "Climate_FwdShortestPath_2080_RCP85.tif"))
  names(climate_c) <- "CLIMATE_C"
  
  ## extremes
  climate_e <- rast(file.path(wtw_path, "climate", "Climate_LaSorte_ExtremeHeatEvents.tif"))
  names(climate_e) <- "CLIMATE_E"
  
  ## refugia
  climate_r <- rast(file.path(wtw_path, "climate", "Climate_Refugia_2080_RCP85.tif"))
  names(climate_r) <- "CLIMATE_R"
  
  # Get Ecosystem Services Data ----
  ## freshwater provision
  fwp <- rast(file.path(wtw_path, "eservices", "water_provision_2a_norm.tif"))
  names(fwp) <- "FRESHW"
  
  ## recreation
  rec <- rast(file.path(wtw_path, "eservices", "rec_pro_1a_norm.tif"))
  names(rec) <- "REC"
  
  # Get Habitat Data ----
  ## forest land cover
  forest <- rast(file.path(wtw_path, "habitat", "FOREST_LC_COMPOSITE_1KM.tif"))
  names(forest) <- "FOREST_LC"
  
  ## grassland
  grass <- rast(file.path(wtw_path, "habitat", "Grassland_AAFC_LUTS_Total_Percent.tif"))
  names(grass) <- "GRASS"
  
  ## wetland
  wet <- rast(file.path(wtw_path, "habitat", "Wetland_comb_proj_diss_90m_Arc.tif"))
  wet <- round(wet,2) # original data has a min of 0.00111111,
  names(wet) <- "WET"
  
  ## lakes
  lakes <- rast(file.path(wtw_path, "habitat", "Lakes_CanVec_50k_ha.tif"))
  names(lakes) <- "LAKES"

  ## rivers
  river <- rast(file.path(wtw_path, "habitat", "grid_1km_water_linear_flow_length_1km.tif"))
  river <- round(river, 2)
  river[river > 50] <- 50 # truncate to 3rd Q
  names(river) <- "RIVER"
  
  ## shoreline
  shore <- rast(file.path(wtw_path, "habitat", "Shoreline.tif"))
  names(shore) <- "SHORE"
  
  # Get Protection Data ----
  ## existing conservation
  parks <- rast(file.path(wtw_path, "protection", "CPCAD_NCC_FS_CA_HA.tif"))
  terra::NAflag(parks) <- 128
  names(parks) <- "PARKS"
  
  # Get Threat Data ----
  ## human footprint index
  hfi <- rast(file.path(wtw_path, "threats", "CDN_HF_cum_threat_20221031_NoData.tif"))
  names(hfi) <- "HFI"
  
  # Create named list
  variables <- list(
    landr = list(theme=NULL, name="Landscape Resilience", shp_name="LANDR", layer=landr, unit="score", fun="custom"),
    sar = list(theme="Biodiversity", name="Species at Risk", shp_name="SAR_RICH" , layer=sar_rich, unit="count", fun="max"),
    end = list(theme="Biodiversity", name="Endemic Species", shp_name="END_RICH", layer=end_rich, unit="count", fun="max"),
    biod = list(theme="Biodiversity", name="Common Species", shp_name="BIOD_RICH", layer=biod_rich, unit="count", fun="max"),
    carbon_s = list(theme="Carbon", name="Carbon Storage", shp_name="CARBON_S", layer=carbon_s, unit="tonnes", fun="sum"),
    carbon_p = list(theme="Carbon", name="Carbon Potential", shp_name="CARBON_P", layer=carbon_p, unit="tonnes/yr", fun="sum"),
    connect = list(theme="Connectivity", name="Connectivity", shp_name="CONNECT", layer=connect, unit="current density", fun="sum"),
    climate_c = list(theme="Climate", name="Climate Forward Shortest-Path Centrality", shp_name="CLIMATE_C", layer=climate_c, unit="index", fun="sum"),
    climate_e = list(theme="Climate/Threat", name="Climate Extreme Heat Events", shp_name="CLIMATE_E", layer=climate_e, unit="index", fun="sum"),
    climate_r = list(theme="Climate", name="Climate Refugia",shp_name="CLIMATE_R", layer=climate_r, shp_name="CLIMATE_R",  unit="index", fun="sum"),
    fwp = list(theme="eServices", name="Freshwater Provision", shp_name="FRESHW", layer=fwp, unit="ha", fun="sum"),
    rec = list(theme="eServices", name="Recreation", layer=rec, shp_name="REC", unit="ha", fun="sum"),
    forest = list(theme="Habitat", name="Forest", layer=forest, shp_name="FOREST_LC", unit="ha", fun="sum"),
    grass = list(theme="Habitat", name="Grassland", layer=grass, shp_name="GRASS",  unit="ha", fun="sum"),
    wet = list(theme="Habitat", name="Wetland", layer=wet, shp_name="WET",  unit="ha", fun="sum"),
    lakes = list(theme="Habitat", name="Lakes", layer=lakes, shp_name="LAKES", unit="ha", fun="sum"),
    river = list(theme="Habitat", name="Rivers", layer=river, shp_name="RIVER", unit="km", fun="sum"),
    shore = list(theme="Habitat", name="Shoreline", layer=shore, shp_name="SHORE",  unit="km", fun="sum"),
    parks = list(theme="Protection", name="CPCAD and NCC", layer=parks, shp_name="PARKS", unit="ha", fun="sum"),
    hfi = list(theme="Threat", name="Human Footprint Index", layer=hfi, shp_name="HFI", unit="index", fun="sum")
  )
  
  # return
  return(variables)
}
