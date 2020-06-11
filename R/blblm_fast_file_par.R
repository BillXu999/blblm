#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


utils::globalVariables(c("."))


#' @export
blblm_fast_file <- function(file, B = 5000) {
  estimates <- future_map(
    file,
    ~ lm_each_subsample_fast_file(file = ., B = B))
  res <- list(estimates = estimates)
  class(res) <- "blblm"
  invisible(res)
}
