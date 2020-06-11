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



#' @title Fit a linear regression model with more than one CPU works
#' @description Fit the linear regression model with data frame input with more than one CPU works
#' @param formula The linear regression model we fitted
#' @param data which is usual is the data frame, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @param cl The muticluster we get from parallel
#' @return blblm object
#' @examples
#' #library(parallel)
#' #cl<- makeCluster(4)
#' # fit<- blblm_par(mpg~., data = mtcars, m = 10, B = 5000,cl)
#' #stopCluster(cl)
#' @export
blblm_par <- function(formula, data, m = 10, B = 5000, cl) {
  data_list <- split_data(data, m)
  n = nrow(data)
  lm_temp<- function(data_list){
    lm_each_subsample(formula = formula, data =data_list, n = n, B = B)
  }
  clusterExport(cl, c("formula","B","n","lm_each_subsample","lm_each_boot","lm1","blbcoef","blbsigma","print.blblm", "sigma.blblm", "coef.blblm","confint.blblm", "predict.blblm", "mean_lwr_upr", "map_mean", "map_cbind", "map_rbind"), envir = environment())
  estimates <- parLapply(cl,data_list,lm_temp)
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}



