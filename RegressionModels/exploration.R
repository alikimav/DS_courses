library(datasets)
library(dplyr)
library(ggplot2)
library(GGally)
library(grid)
library(gridExtra)
library(leaps)
library(caret)


data(mtcars)
# convert certain variables to factors.
indx <- c(2,8:11)
mtcars[, indx] <- lapply(mtcars[, indx], as.factor)

## EDA
# 1. correlations

mtcarsnum <- mtcars[, sapply(mtcars, is.numeric)]
mtcarsnum2 <- mutate(mtcarsnum, power2 = mtcarsnum[, -1]^2)

# What is correlated with mpg?

M2 <- abs(cor(mtcarsnum2))
diag(M2)<-0
which(M2>0.8, arr.ind = TRUE)
which(M2[, 1]>0.7, arr.ind = TRUE)


# correlated covariates

M <- abs(cor(mtcarsnum[,-1]))
diag(M)<-0
which(M>0.8, arr.ind = TRUE)
highlyCorrelated <- findCorrelation(M, cutoff = 0.80, verbose = TRUE)
# print indexes of highly correlated attributes
print(highlyCorrelated)


# PCA
smallmtcars <- mtcarsnum[,c(2,5)]
prComp <- prcomp(smallmtcars)
qplot(prComp$x[,1],prComp$x[,2])


## Regressions

preProc <- preProcess(mtcars[,-1],method="pca",pcaComp=2)
preProc <- preProcess(mtcars[,-1],method=c("center", "scale"))

trainPC <- predict(preProc,mtcars[,-1])

modelFit <- train(mtcars$mpg ~ ., method="lm", data=trainPC)
mtcars3 <- select(mtcars, c(mpg, am, hp, wt, qsec))
# regsubsets0.out <-
#   regsubsets(mpg ~ (.)^2,
#              data = mtcars,
#              nbest = 1,       # 1 best model for each number of predictors
#              nvmax = NULL,    # NULL for no limit on number of variables
#              force.in = NULL, force.out = NULL,
#              method = "exhaustive",
#              intercept = TRUE,
#              really.big = TRUE)
# regsubsets0.out
# summary0.out <- summary(regsubsets0.out)
# as.data.frame(summary0.out$outmat)

regsubsets.out <-
  regsubsets(mpg ~ .,
             data = mtcars,
             nbest = 1,       # 1 best model for each number of predictors
             nvmax = NULL,    # NULL for no limit on number of variables
             force.in = NULL, force.out = NULL,
             method = "exhaustive",
             intercept = TRUE)
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)

# coefficients for best model according to cp
coef(regsubsets.out, which.min(summary.out$cp))

# based on the above results, I will look for the best model with interactions

mtcars2 <- select(mtcars, c(mpg, wt, qsec, am))

regsubsets.out2 <-
  regsubsets(mpg ~ (.)^2,
             data = mtcars2,
             nbest = 1,       # 1 best model for each number of predictors
             nvmax = NULL,    # NULL for no limit on number of variables
             force.in = NULL, force.out = NULL,
             method = "exhaustive",
             intercept = TRUE)
regsubsets.out2
summary.out2 <- summary(regsubsets.out2)
as.data.frame(summary.out2$outmat)

# library(ggvis)
# rsq <- as.data.frame(summary.out$rsq)
# names(rsq) <- "R2"
# rsq %>% 
#   ggvis(x=~ c(1:nrow(rsq)), y=~R2 ) %>%
#   layer_points(fill = ~ R2 ) %>%
#   add_axis("y", title = "R2") %>% 
#   add_axis("x", title = "Number of variables")

library(ggvis)
bicrit <- as.data.frame(summary.out2$bic)
names(bicrit) <- "BIC"
bicrit %>% 
  ggvis(x=~ c(1:nrow(bicrit)), y=~BIC ) %>%
  layer_points(fill = ~ BIC ) %>%
  add_axis("y", title = "BIC") %>% 
  add_axis("x", title = "Number of variables")


model1 <- train(mpg~factor(am), method='lm', data=mtcars)
model2 <- train(mpg~factor(am)+qsec+wt, method='lm', data=mtcars)
model3 <- train(mpg~factor(am)+qsec+wt:qsec+wt:am, method='lm', data=mtcars)

In the first one, the algorithm tries all possible regressions and returns the *best* model from a single predictor to the maximum number indicated by the user (the default is 8); "best" here is quantified using RSS. In the second one, models are fit with each predictor and the one that gives the highest  `|t|` statistic is chosen (unless the corresponding $p$-value is > 0.05 in which case the process is stopped). Then, with the predictor that has just been chosen included, we add the predictor with the highest `|t|` statistic. Predictors are addded in this manner until the  $p$-value is > 0.05. 
