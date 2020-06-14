#' @import purrr
#' @import stats
#' @import readr
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
# from https://github.com/jennybc/googlesheets/blob/master/R/googlesheets.R
utils::globalVariables(c("."))


#' @title Fit a linear regression model with file input
#' @description Fit the linear regression model with data frame input with file input
#' @param formula The linear regression model we fitted
#' @param file which is usual the list of name of .csv files, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' # file<- c("file01.csv","file02.csv")
#' # fit<- blblm_file(mpg~., file, m = 10, B = 5000,cl)
#' @export
blblm_file <- function(formula, file, m = 10, B = 5000) {
  estimates <- map(
    file,
    ~ lm_each_subsample_file(formula = formula, file = ., B = B))
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}


# compute the estimates
lm_each_subsample_file <- function(formula, file, B) {
  replicate(B, lm_each_boot_file(formula, file), simplify = FALSE)
}


# compute the regression estimates for a blb dataset
lm_each_boot_file <- function(formula, file) {
  data<- readr::read_csv(file)
  n = nrow(data)
  freqs <- rmultinom(1, n, rep(1, nrow(data)))
  lm1(formula, data, freqs)
}


