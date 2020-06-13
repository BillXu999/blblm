#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


utils::globalVariables(c("."))

#' @title Fit a linear regression model for a fast method with file input
#' @description Fit the linear regression model with file input
#' @param file which is the file which save the data, but the reapsonse variable should be the first column
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' file<- c("file01.csv","file02.csv")
#' # fit<- blblm_fast_file(file)
#' @export
blblm_fast_file <- function(file, B = 5000) {
  estimates <- map(
    file,
    ~ lm_each_subsample_fast_file(file = ., B = B))
  res <- list(estimates = estimates)
  class(res) <- "blblm"
  invisible(res)
}

# compute the estimates
lm_each_subsample_fast_file <- function(file, B) {
  replicate(B, lm_each_boot_fast_file(file), simplify = FALSE)
}


# compute the regression estimates for a blb dataset
lm_each_boot_fast_file <- function(file) {
  data<- as.matrix(read.csv(file))
  n<- nrow(data)
  freqs <- sample(1:n,n,replace = TRUE)
  data_weighted<- matrix(0,n,ncol(data))
  for(i in 1:n){
    data_weighted[i,] = data[freqs[i],]
  }
  lm_fast(data_weighted)
}


