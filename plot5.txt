# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
## Loads Data Tables NEI and SCC into R's environment
## The script getSourceData.R is available here:
## https://github.com/marcusrw/ExData_Plotting2
source("getSourceData.R")
setwd(base.directory)

## Get the SCCs corresponding to onroad and nonroad sources
## Note we can do this with one grep, since the string "nonroad" contains
## the string "onroad"
if (!exists("vehicleSCCs")){
    typeIsVehicle = grep("onroad",SCC$Data.Category,ignore.case = TRUE)
    vehicleSCCs = SCC$SCC[typeIsVehicle]
}

## Subset the Baltimore Table by the vehicle SCCs
## Skip the computations if the result is already in the R environment
if (!exists("yearlyTotalsBaltVehicles")){
    library(dplyr)
    NEIdf = tbl_df(NEI)
    NEIBaltimore = filter(NEIdf,fips == "24510")
    NEIVehiclesBaltimore = filter(NEIBaltimore,SCC %in% vehicleSCCs)

    ## Get the sum of all vehicle emissions, separated by year
    library(data.table)
    yearlyTotalsBaltVehicles = data.table(NEIVehiclesBaltimore)[,list(vehicleEmissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

filename = "plot5.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotalsBaltVehicles$year,yearlyTotalsBaltVehicles$vehicleEmissionsByYear,type = "l",main = "Change in Vehicle Emissions - Baltimore City, Maryland",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
