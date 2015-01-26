# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
## Loads Data Tables NEI and SCC into R's environment
## The script getSourceData.R is available here:
## https://github.com/marcusrw/ExData_Plotting2
source("getSourceData.R")
setwd(base.directory)

## Skip the computations if the result is already in the R environment
if (!exists("yearlyTotalsBaltimore")){
    ## Subset by the Baltimore County code
    library(dplyr)
    NEIdf = tbl_df(NEI)
    NEIBaltimore = filter(NEIdf,fips == "24510")

    ## Take the sum by year of the emissions
    library(data.table)
    yearlyTotalsBaltimore = data.table(NEIBaltimore)[,list(emissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Generate a plot of the total emissions by year in Baltimore City, Maryland
filename = "plot2.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotalsBaltimore$year,yearlyTotalsBaltimore$emissionsByYear,type = "l",main = "Change in PM2.5 Emissions - Baltimore City, Maryland",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
