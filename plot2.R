# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
source("getSourceData.R")
setwd(base.directory)

## Compute the sum of emissions from all sources in
## Baltimore City, Maryland for each year.
NEIdf = tbl_df(NEI)
NEIBaltimore = filter(NEIdf,fips == "24510")

if (!exists("yearlyTotalsBaltimore")){
    library(data.table)
    yearlyTotalsBaltimore = data.table(NEIBaltimore)[,list(emissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

filename = "plot2.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotalsBaltimore$year,yearlyTotalsBaltimore$emissionsByYear,type = "l",main = "Change in PM2.5 Emissions - Baltimore City, Maryland",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
