#' round_nested_list 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#' 
round_nested_list <- function(nested_list) {
  lapply(nested_list, function(df) {
    df[, sapply(df, is.numeric)] <- lapply(df[, sapply(df, is.numeric)], function(x) round(x, 2))
    df
  })
}

