pollutantmean<-function(directory,pollutant,id=1:332){
  # use full.name=TRUE to keep the name as dir/file so we can access the files
  filelist<-list.files(directory,full.names = TRUE) 
  
  # 1. reading in the csv files
  
  # we need to create an empty vector to read in all the files in specdata - this is given by the empty list temp
  #temp<-vector(mode="list",length=length(filelist))
  #for(i in id){
   # temp[[i]]<-read.csv(filelist[i])
    #}
  # alternatively we can use lapply which is faster
  
  fileread<-lapply(filelist[id],read.csv)
  
  # 2. create data frame of all the data we want to look at (specified in id)
  
  data<-do.call(rbind,fileread) #do.call(what=rbind,args=fileread)
  
  # 3. return the mean of pollutant ignoring NAs
  answer<<-mean(data[,pollutant],na.rm=TRUE)
  }
