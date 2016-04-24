corr<-function(directory,threshold=0){
  id<-1:332
  cr<-NULL
  for(i in 1:length(id)){
    
    k <- complete(directory,i)
    
        if(nrow(k)>threshold){
       #extract columns for sulfate and nitrate to compute correlation
  
        sul<-k[,'sulfate']
        nit<-k[,'nitrate']
  
        a<-cor(sul,nit)
        cr<-append(cr,a)
        }
    }
  return(cr)  
}