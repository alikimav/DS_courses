# Quiz Week 3 - R programming course
library(datasets)
data(iris)
s<-split(iris,iris$Species) #split the df into the different Species

q1<-sapply(s, function(x) mean(x$Sepal.Length)) # finds the mean of column Sepal.Length for each Species
q1<-tapply(iris$Sepal.Length, iris$Species, mean) #same as before

q2<-apply(iris[,1:4], 2, mean) # finds the mean of columns (the argument 2 averages over columns, 1 averages over rows)

data(mtcars)

q3<-with(mtcars, tapply(mpg, cyl, mean)) # calculates the average miles per gallon (mpg) by number of cylinders in the car (cyl)
                                         # equivalently, this can be done by splitting and sapply the mean to x$mpg like for q1 above
