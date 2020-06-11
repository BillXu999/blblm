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
blbglm <- function(formula,family = gaussian, data, m = 10, B = 5000) {
  data_list <- split_data(data, m)
  estimates <- map(
    data_list,
    ~ glm_each_subsample(formula = formula, data = ., n = nrow(data), B = B,family = family))
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}


#' compute the estimates
glm_each_subsample <- function(formula, data, n, B,family) {
  replicate(B, glm_each_boot(formula, data, n,family), simplify = FALSE)
}


#' compute the regression estimates for a blb dataset
glm_each_boot <- function(formula, data, n,family) {
  freqs <- rmultinom(1, n, rep(1, nrow(data)))
  glm1(formula, family, data,freqs)
}


#' estimate the regression estimates based on given the number of repetitions
glm1 <- function(formula, family , data, freqs) {
  # drop the original closure of formula,
  # otherwise the formula will pick a wront variable from the global scope.
  environment(formula) <- environment()
  fit <- glm(formula, family ,data, weights = freqs)
  list(coef = blbcoef(fit), sigma = blbsigma(fit))
}

