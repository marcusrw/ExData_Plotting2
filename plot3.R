# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
## Loads Data Tables NEI and SCC into R's environment
## The script getSourceData.R is available here:
## https://github.com/marcusrw/ExData_Plotting2
source("getSourceData.R")
setwd(base.directory)

## Separate Total emissions by type
## Skip the computations if the result is already in the R environment
if (!exists("totalsBaltimoreByYearAndType")){
    library(data.table)
    totalsBaltimoreByYearAndType = data.table(NEIBaltimore)[,list(totalEmissions = sum(Emissions),numObservations = .N),by=list(year,type)]
}

library(ggplot2)
filename = "plot3.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot3 = qplot(year,totalEmissions,data = totalsBaltimoreByYearAndType,color=type,geom = "line",main = "Total Emissions by Type - Baltimore City, Maryland",xlab = "Year",ylab = "Total Emissions by Type (tons)")
plot3 = plot3 + geom_line(size=2)
print(plot3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
