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



