#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
# from https://github.com/jennybc/googlesheets/blob/master/R/googlesheets.R
utils::globalVariables(c("."))


#' @title Fit a general linear regression model with file imput with more than one CPUs
#' @description Fit the linear regression model with file input with more than one CPUs
#' @param formula The linear regression model we fitted
#' @param file which is usual is the data frame, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @family family which indicates which kinds of glm we use
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' #library(parallel)
#' #cl<- makeCluster(4)
#' # fit<- blbglm.file(Species~., data = read.csv("iris.csv"), m = 10, B = 5000,cl)
#' # stopCluster(cl)
#' @export
blbglm_file <- function(formula,family = gaussian, file, B = 5000) {
  estimates <- map(
    file,
    ~ glm_each_subsample_file(formula = formula, file = ., B = B,family))
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}


#' compute the estimates
glm_each_subsample_file <- function(formula, file, B,family) {
  replicate(B, glm_each_boot_file(formula, file,family), simplify = FALSE)
}


#' compute the regression estimates for a blb dataset
glm_each_boot_file <- function(formula, file,family) {

  data<- read.csv(file)
  n = nrow(data)
  freqs <- rmultinom(1, n, rep(1, nrow(data)))
  glm1(formula,family ,data, freqs)
}


