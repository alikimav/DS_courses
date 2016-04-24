complete <- function(directory,id){
  
  files=list.files(directory,full.names=TRUE)
  temp<-vector(mode='list', length=length(files))
  
  for (i in id){
    
    temp[[i]]<-read.csv(files[[i]]) # place all csv files in list temp.
  } 
  
  data<-do.call(rbind,temp) #data frame - rbind the list of data frames in temp 
  
  #newdata<<-data 
  datatab=NULL
  for (i in id){
  data_subset<-data[data$ID==i,]
  
  # find complete observations
  observs<-data_subset[complete.cases(data_subset),]
  
  #create table with id and nobs
  datatab<-rbind(datatab,data.frame(id=i, nobs=nrow(observs)))
  
  }
  datatab
 
  k<-observs
  #alldata<-data_subset
  #output<-list(k,alldata)
  return(k)
  
}