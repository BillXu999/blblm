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



#' @title Fit a general linear regression model  with more than one CPUs
#' @description Fit the linear regression model  with more than one CPUs
#' @param formula The linear regression model we fitted
#' @param data which is usual is the data frame, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @family family which indicates which kinds of glm we use
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @param cl The muticluster we get from parallel
#' @return blblm object
#' @examples
#' #library(parallel)
#' #cl<- makeCluster(4)
#' # fit<- blbglm_par(Species~., data = read.csv("iris.csv"), m = 10, B = 5000)
#' # stopCluster(cl)
#' @export
blbglm_par <- function(formula,family = gaussian, data, m = 10, B = 5000,cl) {
  data_list <- split_data(data, m)
  n = nrow(data)
  glm_temp<- function(data_list){
    glm_each_subsample(formula = formula, data =data_list, n = n, B = B,family)
  }
  clusterExport(cl, c("formula","B","n","glm_each_subsample","glm_each_boot","glm1","glm"), envir = environment())
  estimates <- parLapply(cl,data_list,glm_temp)
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}



