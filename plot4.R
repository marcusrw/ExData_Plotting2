# Set the working directory to the location of this script
base.directory <- dirname(parent.frame(2)$ofile)
setwd(base.directory)

## Download the source data and read it into R if necessary
source("getSourceData.R")
setwd(base.directory)

if (!exists("yearlyTotalsCoal")){

    ## Coal is mentioned in 4 columns of the SCC table
    ## Find all SCCs that mention Coal
    shortNameMentionsCoal = grep("Coal",SCC$Short.Name,ignore.case = TRUE)
    eiSectorMentionsCoal = grep("Coal",SCC$EI.Sector,ignore.case = TRUE)
    sccLevelThreeMentionsCoal = grep("Coal",SCC$SCC.Level.Three,ignore.case = TRUE)
    sccLevelFourMentionsCoal = grep("Coal",SCC$SCC.Level.Three,ignore.case = TRUE)

    anyMentionsCoal = unique(c(shortNameMentionsCoal,eiSectorMentionsCoal,sccLevelThreeMentionsCoal,sccLevelFourMentionsCoal))
    sccsMentioningCoal = SCC$SCC[anyMentionsCoal]

    NEICoal = filter(NEIdf,SCC %in% sccsMentioningCoal)
    library(data.table)
    yearlyTotalsCoal = data.table(NEICoal)[,list(coalEmissionsByYear = sum(Emissions),numObservations = .N),by=year]
}

## Produce a line graph of Coal emissions by year
filename = "plot4.png"
png(filename = filename , width = 480, height = 480,bg = "transparent")
plot(yearlyTotalsCoal$year,yearlyTotalsCoal$coalEmissionsByYear,type = "l",main = "Change in US PM2.5 Emissions - Coal Sources",ylab = "Total Emissions (tons)",xlab="Year",lwd=3)
dev.off()
print(paste("Plot written to: ",paste(getwd(),filename,sep="/"),sep=""))
