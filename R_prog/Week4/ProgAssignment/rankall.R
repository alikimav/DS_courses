rankall <- function(outcome,num="best"){

  library(dplyr)
  
  ## Read data
  data<-read.csv('data/outcome-of-care-measures.csv', colClasses = 'character')
  
  ## Extract a vector of states. Use the unique fct to determine number of unique elements in vector
  statevec<-data[,'State']
  States<-unique(statevec)
  
  ## Check for invalid inputs
  if(!outcome %in% c('heart attack','heart failure','pneumonia')){stop('invalid outcome')}
  
  if(class(num)=="character"){
  if(!num %in% c('best','worst')){stop('invalid ranking')}}
  
  ## Replace space with dot in input since the data.frame fct below seems to add dots
  outcome <- sub("\\s", ".", outcome)
  
  ## Extract vectors of death mortality rates (part 3)
  HA<-data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
  HF<-data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
  PN<-data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
  
  # Extract vector of Hospital names
  HName<-data$Hospital.Name
  
  # Coerce to numeric
  
  HA<-as.numeric(HA)
  HF<-as.numeric(HF)
  PN<-as.numeric(PN)
  
  ## Create a data frame with State, Death.outcome and Hospital Name
  info<-data.frame("State"=statevec, "heart attack"=HA, "heart failure"=HF, "pneumonia"=PN, "HName"=HName)
  
  ## Arrange by ascending values of given outcome, then by alphabetical order in HName (if there are ties)
  #info<<-arrange(info,  info[,outcome], info[,"HName"]) 
  
  
  # Remove NAs from desired column
  info2<<-info[!is.na(info[,outcome]),]
  
  
  ## Split data frame into groups by state
  infodf<<-split(info2,info2$State)


  #lapply(listname,"[",rows.to.return,cols.to.return,drop=FALSE) - this takes the first row all columns

  ## Put split data frame into order (line 38 above)
   ans<<-lapply(infodf, function(x) x[order(x[,outcome],x[,"HName"]),])

  
  #output1<<-lapply(ans,function(x) x[num,"HName"])
  
  ## Second lapply to pick the HNames for each state according to ranking in num
  output1<<-lapply(ans,function(x,num){ 
    if(class(num)=="character"){
      if(num=="best"){
        return(x[1,"HName"])
      }
      else if(num=="worst"){
        return(x$HName[nrow(x)])
      }
    }
    else{
      return(x=x[num,"HName"])
    }
  },num)
  
  ## Create output data frame
  output<<-data.frame("hospital"=unlist(output1,use.names=FALSE),"state"=names(output1))
  return(output)
  }