setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")

# QUESTION 1
# Have total emissions from PM2.5 decreased in the United States
# from 1999 to 2008? Using the base plotting system, make a plot
# showing the total PM2.5 emission from all sources for each of
# the years 1999, 2002, 2005, and 2008.

# look at our data
head(NEI)
dim(NEI)
summary(NEI)
str(NEI)

# subset only needed columns
NEI.sub <- NEI[, c("Emissions", "year")]

# remove basic dataset
rm(NEI)

# calculate total emissions by year
NEI.Total <- tapply(NEI.sub$Emissions, NEI.sub[, 2], sum)
NEI.Total <- as.data.frame.table(NEI.Total)
names(NEI.Total) <- c("Year", "Emissions")
NEI.Total$Year <- as.integer(as.character(NEI.Total$Year))
NEI.Total$Emissions <- NEI.Total$Emissions / 1000

# init gr device
png(
     filename = "./plot1.png",
     width = 600,
     height = 480,
     units = "px"
)

# plot
plot(
     NEI.Total$Year,
     NEI.Total$Emissions,
     type = "l",
     lwd = 2,
     col = "green",
     main = "The total PM2.5 emissions in the United States",
     ylab = "Emissions (in thousand tons)",
     xlab = "Year",
     xaxt = "n"
)
axis(1, NEI.Total$Year, NEI.Total$Year)
points(NEI.Total, pch = 19)

dev.off()
