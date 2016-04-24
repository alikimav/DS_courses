corr<-function(directory,threshold=0){
cr<-NULL
for(i in seq(332)){    
output<-complete(directory,i)
if(output$nobs>threshold){
  ans<-output$crvalue
  cr<-append(cr,ans)
}

}
return(cr)
}