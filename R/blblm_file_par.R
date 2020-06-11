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


#' @title Fit a linear regression model with file input and with more than one CPU works
#' @description Fit the linear regression model with data frame input with file input and with more than one CPU works.
#' @param formula The linear regression model we fitted
#' @param file which is usual the list of name of .csv files, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' # library(parallel)
#' # cl<- makeCluster(4)
#' # file<- c("file01.csv","file02.csv")
#' # fit<- blblm_file_par(mpg~., file, B = 5000,cl)
#' # stopCluster(cl)
#' @export
blblm_file_par <- function(formula, file, B = 5000, cl) {
  lm_temp<- function(file){
    lm_each_subsample_file(formula = formula, file =file, B = B)
  }
  clusterExport(cl, c("formula","B","lm_each_subsample_file","lm_each_boot_file","lm1","blbcoef","blbsigma","print.blblm", "sigma.blblm", "coef.blblm","confint.blblm", "predict.blblm", "mean_lwr_upr", "map_mean", "map_cbind", "map_rbind"), envir = environment())
  estimates <- parLapply(cl,file,lm_temp)
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}



