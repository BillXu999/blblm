# test for the blblm for four kinds of linear regression
# I will show other cases in the introduction file

test_that("blblm", {

  expect_equal(is.na(sigma(blblm(mpg~disp, mtcars, 10 ,20))), FALSE)
})

test_that("blblm_glm", {
  data<- data.frame(Y = c(1,0,0,1,0,1), X= c(1,0,0,0,0,1))
  expect_equal(is.na(sigma(blblm(mpg~disp, mtcars, 10 ,20))), FALSE)
})

test_that("blblm_fast", {
  x<- cbind(1, as.matrix(mtcars[,'disp']),as.matrix(mtcars[,'hp']))
  y<- as.matrix(mtcars[,'mpg'])
  expect_equal(is.na(sigma(blblm_fast(x,y ,1 ,20))), FALSE)
})













