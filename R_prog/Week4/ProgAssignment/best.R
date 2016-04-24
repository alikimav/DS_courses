best <- function(state,outcome){
  
  library(dplyr)
  
  data<-read.csv('data/outcome-of-care-measures.csv', colClasses = 'character')
  
  statevec<-data[,'State']
  States<-unique(statevec)
  
  # check validity of input arguments
  
  if(!state %in% States){stop('invalid state')}
  if(!outcome %in% c('heart attack','heart failure','pneumonia')){stop('invalid outcome')}
  
  outcome <- sub("\\s", ".", outcome)
  
  # extract vectors of lowest mortality rates (part 1)
  
  #HA<-data$Lower.Mortality.Estimate...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  #HF<-data$Lower.Mortality.Estimate...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  #PN<-data$Lower.Mortality.Estimate...Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  
  # extract vectors of death mortality rates (part 2)
  HA<-data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  HF<-data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  PN<-data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  
  # extract vector of Hospital names
  HName<-data$Hospital.Name
  
  # coerce to numeric
  
  HA<-as.numeric(HA)
  HF<-as.numeric(HF)
  PN<-as.numeric(PN)
  
  # data frame of info I care about
  
  info<<-data.frame("State"=statevec, "heart attack"=HA, "heart failure"=HF, "pneumonia"=PN, "HName"=HName)
  #info<-info[!is.na(info$heart.attack),]
  # Remove NAs from desired column
  info<-info[!is.na(info[,outcome]),]
  #filters by 'state' (given state) 
  x<-filter(info, info$State==state)
  
  # and puts in ascend. order according to column HA then in order according to HName
  x<-arrange(x, x[,outcome], x[,"HName"]) 
  
  
  output<-as.character(x[1,'HName'])
  return(x)
  #return(output)
}