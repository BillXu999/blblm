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


#' @title Fit a general linear regression model with file imput with more than one CPUs
#' @description Fit the linear regression model with file input with more than one CPUs
#' @param formula The linear regression model we fitted
#' @param file which is usual is a list of names of file, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @family family which indicates which kinds of glm we use
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @param cl The muticluster we get from parallel
#' @return blblm object
#' @examples
#' #library(parallel)
#' #cl<- makeCluster(4)
#' # fit<- blbglm_file_par(Species~., data = read.csv("iris.csv"), m = 10, B = 5000,cl)
#' # stopCluster(cl)
#' @export
blbglm_file_par <- function(formula,family = gaussian, file, B = 5000, cl) {
  glm_temp<- function(file){
    glm_each_subsample_file(formula = formula, file =file, B = B,family)
  }
  clusterExport(cl, c("formula","B","glm_each_subsample_file","glm_each_boot_file","glm1","glm","family"), envir = environment())
  estimates <- parLapply(cl,file,glm_temp)
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}



