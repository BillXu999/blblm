#' @import purrr
#' @import furrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"




utils::globalVariables(c("."))

#' @title Fit a linear regression model for a fast method with matrix input and more than one CPUs work
#' @description Fit the linear regression model with file input
#' @param x which is usual matrix as the predictive variable, if you want to include the intercetion, please include the 1 vector in the first colmun
#' @param y the reaponse variable
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' #library(furrr)
#' #suppressWarnings(plan(multiprecess, workers = 4))
#' #x<- matrix(c(1,1,1,4,5,3,1,3,5),3,3)
#' #y<- c(2,4,5)
#' # fit<- blblm_fast_par(x, y)
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