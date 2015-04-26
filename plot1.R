fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataDirName <- "."
fileName <- "NEI_data.zip"

# START PROG

fileDestination <- paste(dataDirName, fileName, sep="/")

# skip directory and file creation if it already exists
if (!file.exists(fileDestination)) {

  # create data directory if it doesn't exist
  if (!file.exists(dataDirName)) {
    dir.create(dataDirName)
  }

  # download data file
  download.file(fileUrl, destfile=fileDestination, method="curl")
  
  # extract file
  unzip(fileDestination)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

dataYears <- c(1999,2002,2005,2008)
NEI.filtered <- NEI[NEI$year %in% dataYears, ]
graphData <- aggregate(NEI.filtered$Emissions, by=list(NEI.filtered$year), FUN=sum)

names(graphData) <- c("year","Emissions")

png("plot1.png", width=480, height=480)
barplot(graphData$Emissions, names=graphData$year, main="Total PM2.5 Emission from All Sources", xlab="Year", ylab="Emissions")
dev.off()
