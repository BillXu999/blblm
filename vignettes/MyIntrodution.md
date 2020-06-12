---
title: "For introduce this package without vignette"
output: 
  html_document: 
    keep_md: yes
---



# blblm
# Introduction

In this project, my work is divided into three parts; the first part is to transform it into two new functions according to the "blblm" function given by the teacher, and these two functions can read the document data for processing and Carry out more than one CPUs process; my second studio, according to the first part of the work to transform, get a function that can handle general linear models, and we can set up different transfer functions to operate, so here we set up a suitable transfer The function can achieve logistic regression; my third job is to implement the bag of little bootrastape based on the linear regression model of Rcpp based on the information provided by the teacher; the last step is to process and rewrite the previous two or three parts of the function to generate a new function So that they can all read files or set more than one CPU. But I must admit that because of the special R version compatibility issue, although the code can run normally, but I can't install my own R package, which brings difficulties to the scoring. I apologize 3,000 times here.

## note: The return of funciton

The "blblm-" or "blbglm-", will return the "blblm" class, wich can do everything, like find the sigma, coefficient value, create the confidence interval and predict and create the predictve interval.

But the "blblm_fast" will return the “blblm_fast” class, which can do compute sigma and compute the coefficent value. 


```r
library(devtools)
```

```
## Loading required package: usethis
```

```r
document()
```

```
## Updating blblm documentation
```

```
## Loading blblm
```

```
## Writing NAMESPACE
## Writing NAMESPACE
```

```r
load_all()
```

```
## Loading blblm
```

```
## 
## Attaching package: 'testthat'
```

```
## The following object is masked from 'package:devtools':
## 
##     test_file
```

```r
library(blblm)
```
## I am very sorry, I do not why I can not install my package, so the only choose for me is to introduce my work here.

### 1. blblm(formula, data, m, B)
This function is provided my professor. This function fit the linear regression model with bag of little bootrastrp. When the data set is large, the result from this funciton could converge. 


```r
fit1<-blblm(mpg~disp+hp,mtcars,m=4,B = 100)
sigma(fit1)
```

```
## [1] 2.244923
```

```r
coef(fit1)
```

```
## (Intercept)        disp          hp 
## 30.97925522 -0.03353296 -0.02714483
```

### 2 blbglm(formula, family, data, m, B)
The formaular is about the model given for us, with this funciton we can fit a lot of model, such as, when family is gaussian, this fucntion can fit the logistic model. When the data set become large, the results we get could converge. 


```r
fit5<-blbglm(Species~.,family = gaussian,read.csv("iris.csv"),B = 100)
sigma(fit5)
```

```
## [1] 0.05361686
```

```r
coef(fit5)
```

```
##  (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##   0.64678207  -0.07446877  -0.19510106   0.21773566   0.29635906
```

### 3 blblm_fast(x, y , m, B)
This funciton can cumpute the linear regression with C code, which is faster than "blblm". X and Y need to be matrix. And if you want to add the interception, just make the first columns of x to be 1 vector. Which is very faster.  


```r
x<- cbind(1, as.matrix(mtcars[,'disp'],as.matrix(mtcars[,'hp'])))
y<- as.matrix(mtcars[,'mpg'])
fit9<-blblm_fast(x,y,m =3,B = 100)
sigma(fit9)
```

```
## [1] 2.958691
```

```r
coef(fit9)
```

```
## [1] 30.39569742 -0.04241583
```
### 4. blblm_file(file, B), blbglm_file(file, family, B), blblm_fast(file, B)

This three function can let us directly use file as the input to get the results we want. Because each time we only consider each file, it is very hard for us to know the total number of the total number. 


```r
fit2<-blblm_file(y~x,c("file01.csv"),B = 100)
sigma(fit2)
```

```
## [1] 0.4852759
```

```r
coef(fit2) 
```

```
## (Intercept)           x 
##   0.6008928  -0.0874751
```

```r
fit6<-blbglm_file(Species~.,family = gaussian,c("iris.csv","iris2.csv"),B = 100)
sigma(fit6)
```

```
## [1] 0.09498817
```

```r
coef(fit6)
```

```
##  (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##   0.38630126  -0.02765924  -0.17260596   0.19605514   0.30615176
```

```r
fit10<-blblm_fast_file(c("file01.csv","file01.csv"),B = 100)
sigma(fit6)
```

```
## [1] 0.09498817
```

```r
coef(fit6)
```

```
##  (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##   0.38630126  -0.02765924  -0.17260596   0.19605514   0.30615176
```

### 5. blblm_par(formula, data, m, B,cl), blbglm_(formula, family, data, m, B,cl),blblm_fast_(x, y , m, B)

This three function just help us consider using more than one CPUs. But for the first two functions. We need we need the following codes:


```r
library(parallel)
#cl<-makeCluster(4)
#aim function with cl 
#stopCluster(cl)
```
With the third funciton, just using following code:

```r
library(furrr)
```

```
## Loading required package: future
```

```r
#supressWarnings(plan(mutiprocessor, workers = 4))
```


```r
cl<- makeCluster(4)
fit3<-blblm_par(mpg~disp+hp,mtcars,m=4,B = 100,cl)
sigma(fit3)
```

```
## [1] 2.133798
```

```r
coef(fit3)
```

```
## (Intercept)        disp          hp 
## 31.87421519 -0.03916024 -0.02128522
```

```r
cl<- makeCluster(4)
fit7<-blbglm_par(Species~.,family = gaussian,read.csv("iris.csv"),m = 5,B = 100,cl)
sigma(fit7)
```

```
## [1] 0.07580773
```

```r
coef(fit7)
```

```
##   (Intercept)  Sepal.Length   Sepal.Width  Petal.Length   Petal.Width 
##  0.3654600718 -0.0007072757 -0.1969655302  0.1683132428  0.3444121073
```

```r
stopCluster(cl)
fit11<-blblm_fast_par(x,y,m =3,B = 100)
```

```
## 
## Attaching package: 'purrr'
```

```
## The following object is masked from 'package:testthat':
## 
##     is_null
```

```r
sigma(fit11)
```

```
## [1] 2.913636
```

```r
coef(fit11)
```

```
## [1] 29.20866092 -0.04057908
```
### 6. blblm_file_par(formula, file, m, B,cl), blbglm_file_(formula, family, file, m, B,cl),blblm_file_fast_(file , B)



```r
cl<-makeCluster(cl)
fit4<-blblm_file_par(y~x,c("file01.csv","file02.csv"),B = 100,cl)
sigma(fit4)
```

```
## [1] 0.4823419
```

```r
coef(fit4)
```

```
## (Intercept)           x 
##   0.5311684  -0.0671456
```

```r
fit8<-blbglm_file_par(Species~.,family = gaussian,c("iris.csv","iris2.csv"),B = 100,cl)
sigma(fit7)
```

```
## [1] 0.07580773
```

```r
coef(fit7)
```

```
##   (Intercept)  Sepal.Length   Sepal.Width  Petal.Length   Petal.Width 
##  0.3654600718 -0.0007072757 -0.1969655302  0.1683132428  0.3444121073
```

```r
stopCluster(cl)

fit12<-blblm_fast_file_par(c("file01.csv","file02.csv"),B = 20)
sigma(fit12)
```

```
## [1] 0.6929596
```

```r
coef(fit12)
```

```
## [1] 0.004181818 0.059017404
```
This is just the combination of before. We can consider fitting model with imput the file and with more than one CPUS.

