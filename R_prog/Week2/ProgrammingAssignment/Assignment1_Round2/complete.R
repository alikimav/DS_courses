complete<-function(directory,id=1:332){
 
  # obtain a list of files, read the data in a file called fileread 
  # and row combine all the data we want to look at in a df called data 
  filelist<-list.files(directory,full.names = TRUE) 
  nobs<-{}
  crvalue<-{}
  for(i in seq(length(id))){
  fileread<-lapply(filelist[id[i]],read.csv)
  data<-do.call(rbind,fileread) 
  # NB:data.frame(Reduce(rbind, fileread)) would also turn the list into a DF but it's slower
  #create an empty matrix to put in the nobs
  
  # use the complete.cases function to return a logical vector of complete obs (=TRUE). 
  # In R, TRUE=1, FALSE=0 hence sum(TRUE,FALSE) will give the number of complete obs (TRUE)
  nobs[i]<-sum(complete.cases(data))
  data<-data[complete.cases(data),]
  crvalue[i]<-cor(data$nitrate,data$sulfate)
  }
  
  answercom<-data.frame(id,nobs)
  
  output<<-data.frame(id,nobs,crvalue)
  return(output)
  # if we wanted to change the column names: colnames(answer)<-c("one","two")
  
}