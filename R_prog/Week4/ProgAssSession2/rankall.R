rankall<-function(outcome,num="best"){
  require(dplyr)
  library(dplyr)
  
  #Passing colClasses with NULL ensures that R won't read in those columns. 
  Classes = c("NULL","character",rep("NULL",4),"character",rep("NULL",3),
              "character",rep("NULL",5),"character",
              rep("NULL",5),"character",rep("NULL",23))
  
  df <- read.csv("outcome-of-care-measures.csv",colClasses=Classes,header=TRUE,
                 na.strings = "Not Available")
  
  colnames(df) <- c("Hospital.Name","State","heartattack",
                    "heartfailure","pneumonia")
  
  df[,3:5]<-sapply(df[,3:5], function(x) as.numeric(x))
  
  # Check for invalid input:  
  
  if(class(num)=="character"){
    if(!num %in% c('best','worst')){stop('invalid ranking')}}
  
  if(!outcome %in% c("heart attack","heart failure", "pneumonia")){stop("invalid outcome")}
  
  # remove spaces from outcome, if any  
  outcome <- sub("\\s", "", outcome) 
  
  dfsubset<<-select(df,State,contains(outcome),Hospital.Name)%>%
    arrange_("State",outcome,"Hospital.Name")
  
  spl<<-split(dfsubset,dfsubset$State)
  if(num=="best"){
    answer<<-sapply(spl, function(x) x[1,"Hospital.Name"])
  }
  else if(num=="worst"){
    answer<<-sapply(spl, function(x) x[nrow(na.omit(x)),"Hospital.Name"])
  }
  else{
    answer<<-sapply(spl, function(x) x[num,"Hospital.Name"])
    }
  dfsol<<-data.frame("hospital"=answer,state=names(spl))

}