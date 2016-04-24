rankhospital<-function(state,outcome,num){
  
  x<-best(state,outcome)
  
  # if statements for worst, best arguments
  
  if(class(num)=="character"){
    if(num=="best"){
      output<-as.character(x[1,"HName"])
    }
    else if(num=="worst"){
      output<-as.character(x[nrow(x),"HName"])
    }
  }
    else{
      output<-as.character(x[num,'HName'])
        }
  
  
  
  return(output)
}