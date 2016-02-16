nestedLM <- function(df){
  
  # check if I have factor variables
  
  sum(sapply(df, function(x) !is.factor(x)))  
  
  predictors <- df[, -1] 
  # for now (delete later):
  predictors <- predictors[, 2:3]
  attach(df)
  
  LSmods <- list()
  for(i in 1:length(predictors)){
    
    LSMods[[i]] <- lm(mpg ~ predictors[, 1:i])
    
  }

}