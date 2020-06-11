#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


utils::globalVariables(c("."))

#' @title Fit a linear regression model for a fast method with file input and more than one CPUs work
#' @description Fit the linear regression model with file input
#' @param file which is the file which save the data, but the reapsonse variable should be the first column
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' #library(furrr)
#' #suppressWarnings(plan(multiprecess, workers = 4))
#' #file<- c("file01.csv","file02.csv")
#' # fit<- blblm_fast_file_par(file)
#' @export
blblm_fast_file_par <- function(file, B = 5000) {
  estimates <- future_map(
    file,
    ~ lm_each_subsample_fast_file(file = ., B = B))
  res <- list(estimates = estimates)
  class(res) <- "blblm"
  invisible(res)
}
