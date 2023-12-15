#' bin_summary 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
#' @export
#' 

bin_summary <- function(vectors, num_bins) {
  summary_list <- list()
  
  for (i in seq_along(vectors)) {
    v <- vectors[[i]]
    
    # Create bins for the current vector using the same bin count
    bins <- cut(v, breaks = num_bins, labels = FALSE)
    
    # Create custom bin names
    bin_names <- as.character(1:num_bins)
    
    # Create a list to store results for the current vector
    bin_summary <- list()
    
    # Loop through each unique bin
    for (j in 1:num_bins) {
      bin_values <- v[bins == j]  # Values in the current bin
      max_val <- ifelse(length(bin_values) == 0, 0, max(bin_values))  # Replace Inf with 0 if no values
      min_val <- ifelse(length(bin_values) == 0, 0, min(bin_values))  # Replace -Inf with 0 if no values
      
      bin_summary[[bin_names[j]]] <- list(
        max_value = max_val,
        min_value = min_val,
        count = length(bin_values)
      )
    }
    
    # Store the summary for the current vector
    summary_list[[as.character(i)]] <- bin_summary
  }
  
  return(summary_list)
}
