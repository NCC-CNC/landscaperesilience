#' read_shp 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
# Load user shapefile
read_shp <- function(userFile){
  if (is.null(userFile)){
    return(NULL)
  }
  shp <- reactive({
    if(!is.data.frame(userFile())) return()
    infiles <- userFile()$datapath
    dir <- unique(dirname(infiles))
    outfiles <- file.path(dir, userFile()$name)
    name <- strsplit(userFile()$name[1], "\\.")[[1]][1] # strip name
    purrr::walk2(infiles, outfiles, ~file.rename(.x, .y))
    x <- try(read_sf(file.path(dir, paste0(name, ".shp"))))
    if(any(class(x)=="try-error")) NULL else x
  })
  
  return(shp)
 
}