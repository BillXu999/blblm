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

