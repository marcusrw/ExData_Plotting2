# Set the working directory to the location of this script
this.directory <- dirname(parent.frame(2)$ofile)
setwd(this.directory)

## Download the data from fileURL and save it as fileName if it hasn't already been downloaded.
## Otherwise do nothing
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFilePath = "exdata_data_NEI_data.zip"
unzippedFolderName = "exdata_data_NEI_data"

if (!file.exists(unzippedFolderName)){
    if (!file.exists(zipFilePath)){
        print("Downloading zipfile")
        download.file(fileURL,destfile = zipFilePath,method = "curl")
        print(paste("zipfile downloaded to ",paste(this.directory,zipFilePath,sep="/"),sep = ""))
    }
    print("Unzipping zipfile")
    unzip(zipFilePath)
}

## Enter the new directory where the datasets are
setwd(paste(this.directory,unzippedFolderName,sep="/"))


## Read the data into R if it's not already there.
if (!exists("NEI")){
    print("Reading summarySCC_PM25.rds")
    NEI = readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")){
    print("Reading Source_Classification_Code.rds")
    SCC = readRDS("Source_Classification_Code.rds")
}

if (!file.exists("SCC.csv")){
    print("Writing SCC to csv")
    write.csv(SCC,file = "SCC.csv")
}

## Return to main directory, and clean up unneeded variables
setwd("./../")
rm(this.directory)
rm(fileURL)
rm(zipFilePath)
rm(unzippedFolderName)
