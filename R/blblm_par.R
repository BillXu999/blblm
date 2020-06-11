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
Get_cores<- function(){
  parallel::detectCores()
}

#' @export
Get_cluster<- function(cores = 4){
  cl<- parallel::makeCluster(4)
}

#' @export
Stop_cluster<- function(cl){
  parallel::stopCluster(cl)
}


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



