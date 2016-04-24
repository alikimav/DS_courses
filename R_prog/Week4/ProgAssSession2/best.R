best <- function(state,outcome){
  
#Passing colClasses with NULL ensures that R won't read in those columns. 
Classes = c("NULL","character",rep("NULL",4),"character",rep("NULL",5),
          "character",rep("NULL",5),"character",
               rep("NULL",5),"character",rep("NULL",21))

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


require(dplyr)
library(dplyr)
# the following will select the State and whatever outcome we input as our cols.(note: use arrange_()
# to pass argument as variable!!!)
dfsubset<<-select(df,State,contains(outcome),Hospital.Name)%>%filter(State==state)%>%
  arrange_(outcome,"Hospital.Name")
# find the index corresponding to the best lower mort. rate
index<<-which.min(dfsubset[,2])
answer<<-dfsubset[index,"Hospital.Name"]
}