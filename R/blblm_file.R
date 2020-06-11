#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
# from https://github.com/jennybc/googlesheets/blob/master/R/googlesheets.R
utils::globalVariables(c("."))


#' @export
blblm_file <- function(formula, file, m = 10, B = 5000) {
  estimates <- map(
    file,
    ~ lm_each_subsample_file(formula = formula, file = ., B = B))
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}


#' compute the estimates
lm_each_subsample_file <- function(formula, file, B) {
  replicate(B, lm_each_boot_file(formula, file), simplify = FALSE)
}


#' compute the regression estimates for a blb dataset
lm_each_boot_file <- function(formula, file) {
  data<- read.csv(file)
  n = nrow(data)
  freqs <- rmultinom(1, n, rep(1, nrow(data)))
  lm1(formula, data, freqs)
}


