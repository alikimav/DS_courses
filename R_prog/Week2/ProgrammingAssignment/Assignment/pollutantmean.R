pollutantmean <- function(directory, pollutant,id=1:332){
  
  files=list.files(directory,full.names=TRUE)
  temp<-vector(mode='list', length=length(files))
  
 #   for (i in seq_along(files)){
          
       for (i in id){
        temp[[i]]<-read.csv(files[[i]]) # place all csv files in list temp.
    } 

    data<-do.call(rbind,temp) #data frame - rbind the list of data frames in temp 
                                
    newdata<-data # make data accessible globally so I can play with it in .GlobalEnv. 
                  #   Does <<- always assigns to the GlobalEnv? Check later.
    
    data_subset=data[data$ID %in% id,]
    mean(data_subset[,pollutant], na.rm=TRUE)
    
}