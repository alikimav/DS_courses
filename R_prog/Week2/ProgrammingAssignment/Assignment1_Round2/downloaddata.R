# download data
setwd("/Users/alikimavromoustaki/Dropbox/it_s_time/DataScienceSpecialization/2.R_prog/Week2/ProgrammingAssignment/Assignment1_Round2/")
fileUrl<-"https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip"
if(!file.exists("specdata.zip")){
download.file(fileUrl,destfile = "./specdata.zip")
}
library(utils)
unzip("./specdata.zip")


