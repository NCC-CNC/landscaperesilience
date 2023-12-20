#' shp_field_valid 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#'

shp_field_valid <- function(field_name) {
  
  if (is.na(field_name)) {
    return(NA)
  }
  
  # Check length <= 9 characters
  length_condition <- nchar(field_name) <= 9
  
  # Check if it doesn't start with a number
  not_start_with_number <- !grepl("^\\d", field_name)
  
  # Define symbols to exclude
  symbols <- "!@#$%^&*()-+=[]{}|\\:;\'\"<>,.?~"
  
  # Check if symbols are not present in the string
  no_symbols <- !grepl(paste0("[", gsub("([][|\\\\])", "\\\\\\1", symbols), "]"), field_name, perl = TRUE)
  
  # Combine conditions using AND operator (&)
  if (length_condition & not_start_with_number & no_symbols) {
    return(field_name)
  } else {
    return(NA)
  }
}