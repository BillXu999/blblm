# blblm


## I am very sorry, I do not why I can not install my package, so the only choose for me is to introduce my work here.

### 1. blblm(formula, data, m, B)
This function is provided my professor. This function fit the linear regression model with bag of little bootrastrp. When the data set is large, the result from this funciton could converge. 

### 2 blbglm(formula, family, data, m, B)
The formaular is about the model given for us, with this funciton we can fit a lot of model, such as, when family is gaussian, this fucntion can fit the logistic model. When the data set become large, the results we get could converge. 

### 3 blblm_fast(x, y , m, B)
This funciton can cumpute the linear regression with C code, which is faster than "blblm". X and Y need to be matrix. And if you want to add the interception, just make the first columns of x to be 1 vector. Which is very faster.  

### 3. blblm_file(file, B), blbglm_file(file, family, B), blblm_fast(file, B)

This three function can let us directly use file as the input to get the results we want. Because each time we only consider each file, it is very hard for us to know the total number of the total number. 

### 4 blblm_par(formula, data, m, B,cl), blbglm_(formula, family, data, m, B,cl),blblm_fast_(x, y , m, B)

This three function just help us consider using more than one CPUs. But for the first two functions. We need we need the following codes:

```{r}
library(parallel)
cl<-makeCluster(4)
#aim function with cl 
stopCloster(cl)
```
With the third funciton, just using following code:
```{r}
library(furrr)
supressWarnings(plan(mutiprocessor, workers = 4))
```
### 5 blblm_file_par(formula, file, m, B,cl), blbglm_file_(formula, family, file, m, B,cl),blblm_file_fast_(file , B)

This is just the combination of 3 and 4. We can consider fitting model with imput the file and with more than one CPUS.

Because for some reason I can not show the markdown, I just run the code in the cript, and it is convient you wanner to check.
```{r}
fit1<-blblm(mpg~disp+hp,mtcars,m=4,B = 100)
> sigma(fit1)
[1] 2.493778
> coef(fit1)
(Intercept)        disp          hp 
31.67113877 -0.03081674 -0.03085175 
> 
> fit2<-blblm_file(y~x,c("file01.csv","file02.csv","file03.csv","file04.csv"),B = 100)
> sigma(fit2)
[1] 0.7042189
> coef(fit2)
(Intercept)           x 
 0.32219195 -0.04626914 
> 
> cl<- makeCluster(4)
> fit3<-blblm_par(mpg~disp+hp,mtcars,m=4,B = 100,cl)
> sigma(fit3)
[1] 2.271096
> coef(fit3)
(Intercept)        disp          hp 
27.10406005 -0.03362257  0.00777943 
> stopCluster(cl)
> 
> cl<- makeCluster(4)
> fit4<-blblm_file_par(y~x,c("file01.csv","file02.csv"),B = 100,cl)
> sigma(fit4)
[1] 0.4714975
> coef(fit4)
(Intercept)           x 
 0.54526787 -0.07114386 
> stopCluster(cl)
> 
> ## Show the blgblm, the general linear model
> fit5<-blbglm(Species~.,family = gaussian,read.csv("iris.csv"),B = 100)
> sigma(fit5)
[1] 0.05697478
> coef(fit5)
 (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
  0.48496823  -0.02672559  -0.20713714   0.19076188   0.31928116 
> 
> 
> fit6<-blbglm_file(Species~.,family = gaussian,c("iris.csv","iris2.csv"),B = 100)
> sigma(fit6)
[1] 0.09459766
> coef(fit6)
 (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
  0.36121506  -0.02905021  -0.16700439   0.20946055   0.27416530 
> 
> cl<- makeCluster(4)
> fit7<-blbglm_par(Species~.,family = gaussian,read.csv("iris.csv"),m = 5,B = 100,cl)
> sigma(fit7)
[1] 0.07214034
> coef(fit7)
 (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
  0.41273404  -0.03144118  -0.17030024   0.16711677   0.39612827 
> stopCluster(cl)
> 
> cl<- makeCluster(4)
> fit8<-blbglm_file_par(Species~.,family = gaussian,c("iris.csv","iris2.csv"),B = 100,cl)
> sigma(fit7)
[1] 0.07214034
> coef(fit7)
 (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
  0.41273404  -0.03144118  -0.17030024   0.16711677   0.39612827 
> stopCluster(cl)
> 
> 
> ## show the blblm_fast
> x<- cbind(1, as.matrix(mtcars[,'disp'],as.matrix(mtcars[,'hp'])))
> y<- as.matrix(mtcars[,'mpg'])
> fit9<-blblm_fast(x,y,m =3,B = 100)
> sigma(fit9)
[1] 2.62159
> coef(fit9)
[1] 29.78049485 -0.04179382
> 
> 
> fit10<-blblm_fast_file(c("file01.csv","file01.csv"),B = 100)
> sigma(fit6)
[1] 0.09459766
> coef(fit6)
 (Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
  0.36121506  -0.02905021  -0.16700439   0.20946055   0.27416530 
> 
> fit11<-blblm_fast_par(x,y,m =3,B = 100)
> sigma(fit11)
[1] 2.85688
> coef(fit11)
[1] 29.39288968 -0.03919359
> 
> fit11<-blblm_fast_file_par(c("file01.csv","file02.csv"),B = 20)
> sigma(fit11)
[1] 0.711405
> coef(fit11)
[1]  0.13215769 -0.02147053
> 
```
