#' @import purrr
#' @import furrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"




utils::globalVariables(c("."))


#' @export
blblm_fast_par <- function(x,y, m = 10, B = 5000) {
  data<- cbind(y,x)
  n = nrow(data)
  data_list <- split_data(as.data.frame(data), m)
  estimates <- future_map(
    data_list,
    ~ lm_each_subsample_fast(data = ., n , B = B))
  res <- list(estimates = estimates)
  class(res) <- "blblm"
  invisible(res)
}