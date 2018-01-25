setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")

# QUESTION 2
# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
# system to make a plot answering this question.

# look at our data
head(NEI)
dim(NEI)
summary(NEI)
str(NEI)

# subset only needed columns
NEI.sub <- NEI[NEI$fips == "24510", c("Emissions", "year")]

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
     filename = "./plot2.png",
     width = 600,
     height = 480,
     units = "px"
)

# plot to file
plot(
     NEI.Total$Year,
     NEI.Total$Emissions,
     type = "l",
     lwd = 2,
     col = "green",
     main = "The total PM2.5 emissions in the Baltimore City, Maryland",
     ylab = "Emissions (in thousand tons)",
     xlab = "Year",
     xaxt = "n"
)
axis(1, NEI.Total$Year, NEI.Total$Year)
points(NEI.Total, pch = 19)

dev.off()
