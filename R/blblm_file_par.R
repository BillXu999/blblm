#' @import purrr
#' @import stats
#' @import parallel
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
# from https://github.com/jennybc/googlesheets/blob/master/R/googlesheets.R
utils::globalVariables(c("."))


#' @export
blblm_file_par <- function(formula, file, m = 10, B = 5000, cl) {
  lm_temp<- function(file){
    lm_each_subsample_file(formula = formula, file =file, B = B)
  }
  clusterExport(cl, c("formula","B","lm_each_subsample_file","lm_each_boot_file","lm1","blbcoef","blbsigma","print.blblm", "sigma.blblm", "coef.blblm","confint.blblm", "predict.blblm", "mean_lwr_upr", "map_mean", "map_cbind", "map_rbind"), envir = environment())
  estimates <- parLapply(cl,file,lm_temp)
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}



