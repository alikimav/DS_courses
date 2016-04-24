## R Programming - assignment 3 (session 2)

url<-"https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
if(!file.exists("./data3.zip")){
  download.file(url,destfile = "./data3.zip",method="curl")
  unzip("./data3.zip")
}

outcome<-read.csv(file = "outcome-of-care-measures.csv", header = TRUE, colClasses = "character")

