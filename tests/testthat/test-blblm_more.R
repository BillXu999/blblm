# test for the blblm for four kinds of linear regression
# I will show other cases in the introduction file

test_that("blblm", {

  expect_equal(is.na(sigma(blblm_general(mpg~disp, mtcars, 10 ,20))), FALSE)
})


test_that("blblm_glm", {
  expect_equal(is.na(sigma(blbglm(Species~.,family = gaussian ,read.csv("iris.csv"), 5 ,20))), FALSE)
})


test_that("blblm_fast", {
  x<- cbind(1, as.matrix(mtcars[,'disp']),as.matrix(mtcars[,'hp']))
  y<- as.matrix(mtcars[,'mpg'])
  expect_equal(is.na(sigma(blblm_fast(x,y ,1 ,20))), FALSE)
})

test_that("blblm_fast_par", {
  library(furrr)
  suppressWarnings(plan(multiprocess, wokers = 4))
  x<- cbind(1, as.matrix(mtcars[,'disp']),as.matrix(mtcars[,'hp']))
  y<- as.matrix(mtcars[,'mpg'])
  expect_equal(is.na(sigma(blblm_fast(x,y ,1 ,20))), FALSE)
})

test_that("blblm_file", {

  expect_equal(is.na(sigma(blblm_file(y~x,c("file01.csv"),B = 100))), FALSE)
})

test_that("blbglm_file", {

  expect_equal(is.na(sigma(blbglm_file(Species~.,family = gaussian,c("iris.csv","iris2.csv"),B = 100))), FALSE)
})

test_that("blblm_fast_file", {

  expect_equal(is.na(sigma(blblm_fast_file(c("file01.csv","file01.csv"),B = 100))), FALSE)
})























