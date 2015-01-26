# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
## Loads Data Tables NEI and SCC into R's environment
## The script getSourceData.R is available here:
## https://github.com/marcusrw/ExData_Plotting2
source("getSourceData.R")
setwd(base.directory)

## Filter the data by county code (fips)
library(dplyr)
NEIdf = tbl_df(NEI)
## Subset the NEI table by Baltimore City, Maryland (fips == 24510)
NEIBaltimore = filter(NEIdf,fips == "24510")
## Subset the NEI table by LA County (fips == 06037)
NEILACounty = filter(NEIdf,fips == "06037")

## Get the SCCs corresponding to onroad and nonroad sources
## Note we can do this with one grep, since the string "nonroad" contains
## the string "onroad"
## Skip the computations if the result is already in the R environment
if (!exists("vehicleSCCs")){
    typeIsVehicle = grep("onroad",SCC$Data.Category,ignore.case = TRUE)
    vehicleSCCs = SCC$SCC[typeIsVehicle]
}

library(data.table)
## Subset the Baltimore Table by the vehicle SCCs
## Skip the computations if the result is already in the R environment
if (!exists("yearlyTotalsBaltVehicles")){
NEIVehiclesBaltimore = filter(NEIBaltimore,SCC %in% vehicleSCCs)
yearlyTotalsBaltVehicles = data.table(NEIVehiclesBaltimore)[,list(vehicleEmissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Subset the LA County Table by the vehicle SCCs
## Skip the computations if the result is already in the R environment
if (!exists("yearlyTotalsLACVehicles")){
NEIVehiclesLACounty = filter(NEILACounty,SCC %in% vehicleSCCs)
yearlyTotalsLACVehicles = data.table(NEIVehiclesLACounty)[,list(vehicleEmissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Plot the Baltimore and LA County data on separate plots, so we can
## see the variability on both curves easily
filename = "plot6.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
par(mfrow=c(2,1))
plot(yearlyTotalsBaltVehicles$year,yearlyTotalsBaltVehicles$vehicleEmissionsByYear,type = "l",main = "Change in Vehicle Emissions - Baltimore City",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
plot(yearlyTotalsLACVehicles$year,yearlyTotalsLACVehicles$vehicleEmissionsByYear,type = "l",main = "Change in Vehicle Emissions - LA County",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
