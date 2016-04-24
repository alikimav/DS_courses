rankhospital<-function(state,outcome,num="best"){
  
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
  
  if(!state %in% unique(df$State)){stop("invalid state")}
  
  if(!outcome %in% c("heart attack","heart failure", "pneumonia")){stop("invalid outcome")}
  
  # remove spaces from outcome, if any  
  outcome <- sub("\\s", "", outcome)
  

  dfsubset<<-select(df,State,contains(outcome),Hospital.Name)%>%filter(State==state)%>%
    arrange_(outcome,"Hospital.Name")
  if(num=="best"){
    num=1
  }
  else if(num=="worst"){
    num=nrow(na.omit(dfsubset))
  }
  else{
    num=num
  }
  
  answer<<-dfsubset[num,"Hospital.Name"]  
}