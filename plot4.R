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
if (!exists("yearlyTotalsCoal")){

    ## Coal is mentioned in 4 columns of the SCC table
    ## Find all SCCs that mention Coal
    shortNameMentionsCoal = grep("Coal",SCC$Short.Name,ignore.case = TRUE)
    eiSectorMentionsCoal = grep("Coal",SCC$EI.Sector,ignore.case = TRUE)
    sccLevelThreeMentionsCoal = grep("Coal",SCC$SCC.Level.Three,ignore.case = TRUE)
    sccLevelFourMentionsCoal = grep("Coal",SCC$SCC.Level.Three,ignore.case = TRUE)

    anyMentionsCoal = unique(c(shortNameMentionsCoal,eiSectorMentionsCoal,sccLevelThreeMentionsCoal,sccLevelFourMentionsCoal))
    sccsMentioningCoal = SCC$SCC[anyMentionsCoal]

    ## Clean up garbage, anything we won't use again
    rm(shortNameMentionsCoal)
    rm(eiSectorMentionsCoal)
    rm(sccLevelThreeMentionsCoal)
    rm(sccLevelFourMentionsCoal)
    rm(anyMentionsCoal)

    ## Filter the original dataset by sccsMentioningCoal
    library(dplyr)
    NEIdf = tbl_df(NEI)
    NEICoal = filter(NEIdf,SCC %in% sccsMentioningCoal)

    ## Get the sum of all coal emissions, separated by year
    library(data.table)
    yearlyTotalsCoal = data.table(NEICoal)[,list(coalEmissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Produce a line graph of Coal emissions by year
filename = "plot4.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotalsCoal$year,yearlyTotalsCoal$coalEmissionsByYear,type = "l",main = "Change in US PM2.5 Emissions - Coal Sources",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
