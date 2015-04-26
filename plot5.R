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

NEISCC <- merge(NEI,SCC, by="SCC")

dataYears <- c(1999, 2002, 2005, 2008)
NEISCC.filtered <- NEISCC[NEISCC$year %in% dataYears, ]
NEISCC.filtered <- NEISCC.filtered[NEISCC.filtered$fips == "24510", ]
NEISCC.filtered <- NEISCC.filtered[grep("^Mobile",NEISCC.filtered$EI.Sector, ignore.case=TRUE, perl=TRUE), ]
graphData <- aggregate(NEISCC.filtered$Emissions, by=list(NEISCC.filtered$year, NEISCC.filtered$EI.Sector), FUN=sum)
names(graphData) <- c("year","Sectors","Emissions")

resultGraph <- ggplot(graphData, aes(year, Emissions, fill=Sectors)) +
  geom_bar(position="stack", stat="identity") +
  coord_cartesian(xlim = c(1997, 2010)) +
  scale_x_discrete(limit = dataYears) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("PM2.5 Emission from Motor Vehicles in Baltimore City")

ggsave(resultGraph, file="plot5.png")
