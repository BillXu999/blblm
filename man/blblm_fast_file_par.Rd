% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blblm_fast_file_par.R
\name{blblm_fast_file_par}
\alias{blblm_fast_file_par}
\title{Fit a linear regression model for a fast method with file input and more than one CPUs work}
\usage{
blblm_fast_file_par(file, B = 5000)
}
\arguments{
\item{file}{which is the file which save the data, but the reapsonse variable should be the first column}

\item{B}{which is a numeric variable, indicates number of bootstraps we need}
}
\value{
blblm object
}
\description{
Fit the linear regression model with file input
}
\examples{
#library(furrr)
#suppressWarnings(plan(multiprecess, workers = 4))
#file<- c("file01.csv","file02.csv")
# fit<- blblm_fast_file_par(file)
}
