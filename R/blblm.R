#' @import purrr
#' @import stats
#' @importFrom magrittr %>%
#' @importFrom utils capture.output
#' @details
#' Linear Regression with Little Bag of Bootstraps
"_PACKAGE"


utils::globalVariables(c("."))


#' @title Fit a linear regression model
#' @description Fit the linear regression model with data frame input
#' @param formula The linear regression model we fitted
#' @param data which is usual is the data frame, which is the data we imput.
#' @param m  which is numeric variables, indicates the number of splits we need
#' @param B which is a numeric variable, indicates number of bootstraps we need
#' @return blblm object
#' @examples
#' # fit<- blblm_general(mpg~., data = mtcars, m = 10, B = 5000)
#' @export
blblm_general <- function(formula, data, m = 10, B = 5000) {
  data_list <- split_data(data, m)
  estimates <- map(
    data_list,
    ~ lm_each_subsample(formula = formula, data = ., n = nrow(data), B = B))
  res <- list(estimates = estimates, formula = formula)
  class(res) <- "blblm"
  invisible(res)
}


# split data into m parts of approximated equal sizes
split_data <- function(data, m) {
  idx <- sample.int(m, nrow(data), replace = TRUE)
  data %>% split(idx)
}


# compute the estimates
lm_each_subsample <- function(formula, data, n, B) {
  replicate(B, lm_each_boot(formula, data, n), simplify = FALSE)
}


# compute the regression estimates for a blb dataset
lm_each_boot <- function(formula, data, n) {
  freqs <- rmultinom(1, n, rep(1, nrow(data)))
  lm1(formula, data, freqs)
}


# estimate the regression estimates based on given the number of repetitions
lm1 <- function(formula, data, freqs) {
  # drop the original closure of formula,
  # otherwise the formula will pick a wront variable from the global scope.
  environment(formula) <- environment()
  fit <- lm(formula, data, weights = freqs)
  list(coef = blbcoef(fit), sigma = blbsigma(fit))
}


# compute the coefficients from fit
blbcoef <- function(fit) {
  coef(fit)
}


# compute sigma from fit
blbsigma <- function(fit) {
  p <- fit$rank
  y <- model.extract(fit$model, "response")
  e <- fitted(fit) - y
  w <- fit$weights
  sqrt(sum(w * (e^2)) / (sum(w) - p))
}



#' @title The method for the blblm class to print
#' @description For a blblm object input, we get the print
#' @param x Which is a blblm variable.
#' @param ... Nothing
#' @return char return the formula from the blblm variable
#' @examples
#' # fit<- blblm(mpg~., data = mtcars, m = 10, B = 5000)
#' # print(fit)
#' @export
#' @method print blblm
print.blblm <- function(x, ...) {
  cat("blblm model:", capture.output(x$formula))
  cat("\n")
}


#' @title The method for the blblm class to get the sigma
#' @description For a blblm object input, we get the sigma
#' @param object Which is a blblm variable.
#' @param confidence It the confidence is needed
#' @param level The level of alpha
#' @param ... Nothing
#' @return sigma which is the sigema of fit
#' @examples
#' # fit<- blblm(mpg~., data = mtcars, m = 10, B = 5000)
#' # sigma(fit)
#' @export
#' @method sigma blblm
sigma.blblm <- function(object, confidence = FALSE, level = 0.95, ...) {
  est <- object$estimates
  sigma <- mean(map_dbl(est, ~ mean(map_dbl(., "sigma"))))
  if (confidence) {
    alpha <- 1 - 0.95
    limits <- est %>%
      map_mean(~ quantile(map_dbl(., "sigma"), c(alpha / 2, 1 - alpha / 2))) %>%
      set_names(NULL)
    return(c(sigma = sigma, lwr = limits[1], upr = limits[2]))
  } else {
    return(sigma)
  }
}





#' @title The method for the blblm class to get the coefficient
#' @description For a blblm object input, we get the coef
#' @param object Which is a blblm variable.
#' @param ... nothing
#' @return coef which is the coefficient of fit
#' @examples
#' # fit<- blblm(mpg~., data = mtcars, m = 10, B = 5000)
#' # coef(fit)
#' @export
#' @method coef blblm
coef.blblm <- function(object, ...) {
  est <- object$estimates
  map_mean(est, ~ map_cbind(., "coef") %>% rowMeans())
}


#' @title The method for the blblm class to get the confident interval
#' @description For a blblm object input, we get the confident interval
#' @param object Which is a blblm variable.
#' @param parm The parameter you focus on
#' @param level The level of alpha\\
#' @param ... Nothing
#' @return sigma which is the confident interval of fit
#' @examples
#' # fit<- blblm(mpg~., data = mtcars, m = 10, B = 5000)
#' # confint(fit)
#' @export
#' @method confint blblm
confint.blblm <- function(object, parm = NULL, level = 0.95, ...) {
  if (is.null(parm)) {
    parm <- attr(terms(object$formula), "term.labels")
  }
  alpha <- 1 - level
  est <- object$estimates
  out <- map_rbind(parm, function(p) {
    map_mean(est, ~ map_dbl(., list("coef", p)) %>% quantile(c(alpha / 2, 1 - alpha / 2)))
  })
  if (is.vector(out)) {
    out <- as.matrix(t(out))
  }
  dimnames(out)[[1]] <- parm
  out
}




#' @title The method for the blblm class to predict
#' @description For a blblm object input, we get the predictive value and the confident interval for the variable.
#' @param object Which is a blblm variable.
#' @param new_data which is a data set, it is the value we want to predict
#' @param confidence Whcih is the alpha level we want to choose
#' @param level The level of alpha
#' @param ... Nothing
#' @return  which returns the predictive value or the confidence interval.
#' @examples
#' # fit<- blblm(mpg~disp, data = mtcars, m = 10, B = 5000)
#' newdata<- data.frame(disp = 10)
#' # predict(fit,newdata)
#' @export
#' @method predict blblm
predict.blblm <- function(object, new_data, confidence = FALSE, level = 0.95, ...) {
  est <- object$estimates
  X <- model.matrix(reformulate(attr(terms(object$formula), "term.labels")), new_data)
  if (confidence) {
    map_mean(est, ~ map_cbind(., ~ X %*% .$coef) %>%
      apply(1, mean_lwr_upr, level = level) %>%
      t())
  } else {
    map_mean(est, ~ map_cbind(., ~ X %*% .$coef) %>% rowMeans())
  }
}


mean_lwr_upr <- function(x, level = 0.95) {
  alpha <- 1 - level
  c(fit = mean(x), quantile(x, c(alpha / 2, 1 - alpha / 2)) %>% set_names(c("lwr", "upr")))
}

map_mean <- function(.x, .f, ...) {
  (map(.x, .f, ...) %>% reduce(`+`)) / length(.x)
}

map_cbind <- function(.x, .f, ...) {
  map(.x, .f, ...) %>% reduce(cbind)
}

map_rbind <- function(.x, .f, ...) {
  map(.x, .f, ...) %>% reduce(rbind)
}
