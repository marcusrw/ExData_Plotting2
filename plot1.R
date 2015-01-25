# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
## Loads Data Tables NEI and SCC into R's environment
## The script getSourceData.R is available here:
## https://github.com/marcusrw/ExData_Plotting2
source("getSourceData.R")
setwd(base.directory)

## Compute the sum of emissions from all sources for each year.
## Skip the computations if the result is already in the R environment
if (!exists("yearlyTotals")){
    library(data.table)
    yearlyTotals = data.table(NEI)[,list(emissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Plot the total emissions for each year
filename = "plot1.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotals$year,yearlyTotals$emissionsByYear,type = "l",main = "Decrease in US PM2.5 Emissions from 1999 to 2008",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
