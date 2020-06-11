% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blblm.R
\name{coef.blblm}
\alias{coef.blblm}
\title{The method for the blblm class}
\usage{
\method{coef}{blblm}(object, ...)
}
\arguments{
\item{x}{Which is a blblm variable.}
}
\value{
coef which is the coefficient of fit
}
\description{
For a blblm object input, we get the coef
}
\examples{
# fit<- blblm(mpg~., data = mtcars, m = 10, B = 5000)
# coef(fit)
}