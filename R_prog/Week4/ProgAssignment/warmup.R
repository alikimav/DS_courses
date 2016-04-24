# Part 1 (ungraded)

outcome<-read.csv('outcome-of-care-measures.csv', colClasses = 'character')
head(outcome)

outcome[,11]<-as.numeric(outcome[,11]) # we read the data as character (line 3) so we need to coerce the column to be numeric

