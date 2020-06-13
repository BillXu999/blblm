#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"




utils::globalVariables(c("."))

#' @title Fit a linear regression model for a fast method
#' @description Fit the linear regression model with matrix input
#' @param x which is usual matrix as the predictive variable, if you want to include the intercetion, please include the 1 vector in the first colmun
#' @param y the reaponse variable
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' #x<- matrix(c(1,1,1,4,5,3,1,3,5),3,3)
#' #y<- c(2,4,5)
#' # fit<- blblm_fast(x, y)
#' @export
blblm_fast <- function(x,y, m = 10, B = 5000) {
  data<- cbind(y,x)
  n = nrow(data)
  data_list <- split_data(as.data.frame(data), m)
  estimates <- map(
    data_list,
    ~ lm_each_subsample_fast(data = ., n , B = B))
  res <- list(estimates = estimates)
  class(res) <- "blblm"
  invisible(res)
}

# compute the estimates
lm_each_subsample_fast <- function(data, n, B) {
  replicate(B, lm_each_boot_fast(data, n), simplify = FALSE)
}


# compute the regression estimates for a blb dataset
lm_each_boot_fast <- function(data, n) {
  data<- as.matrix(data)
  k<- nrow(data)
  freqs <- sample(1:k,n,replace = TRUE)
  data_weighted<- matrix(0,n,ncol(data))
  for(i in 1:n){
        data_weighted[i,] = data[freqs[i],]
  }
  lm_fast(data_weighted)
}


# estimate the regression estimates based on given the number of repetitions
lm_fast <- function(data) {
  y<- data[,1]
  x<- data[,-1]
  fit<- lmc(x,y)
  list(coef = fit$coefficients, sigma = sqrt(fit$sig2))
}


