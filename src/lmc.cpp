#include <RcppArmadillo.h>
//[[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
// [[Rcpp::export]]
List lmc(const arma::mat& X, const arma::colvec& y) {
  int n = X.n_rows, k = X.n_cols;
  arma::colvec coef = arma::solve(X, y);    // fit model y ~ X
  arma::colvec res  = y - X*coef;           // residuals
  double sig2 = arma::as_scalar(arma::trans(res)*res/(n-k));
  return List::create(Named("coefficients") = coef,
                      Named("res")       = res,
                     Named("df.residual")  = n - k,
                      Named("sig2")  = sig2);
}


