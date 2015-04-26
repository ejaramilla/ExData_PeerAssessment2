fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataDirName <- "."
fileName <- "NEI_data.zip"

# START PROG
library(ggplot2)

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

dataYears <- c(1999, 2002, 2005, 2008)
NEI.filtered <- NEI[NEI$year %in% dataYears, ]
NEI.filtered <- NEI.filtered[NEI.filtered$fips == "24510", ]
graphData <- aggregate(NEI.filtered$Emissions, by=list(NEI.filtered$year, NEI.filtered$type), FUN=sum)

names(graphData) <- c("year","type","Emissions")

resultGraph <- ggplot(graphData, aes(year, Emissions, fill=type)) +
  geom_bar(position="dodge", stat="identity") +
  coord_cartesian(xlim = c(1997, 2010)) +
  scale_x_discrete(limit = dataYears) +
  facet_grid(. ~ type) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("PM2.5 Emission from Baltimore City by Type")

ggsave(resultGraph, file="plot3.png")
