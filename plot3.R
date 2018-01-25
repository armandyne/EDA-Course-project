setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")

# QUESTION 3
# Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen
# decreases in emissions from 1999–2008 for Baltimore City? Which have
# seen increases in emissions from 1999–2008? Use the ggplot2 plotting
# system to make a plot answer this question.

# look at our data
head(NEI)
dim(NEI)
summary(NEI)
str(NEI)

# subset only needed columns
NEI.sub <- NEI[NEI$fips == "24510", c("Emissions", "year", "type")]

# calculate total emissions by year and type
NEI.Total <- tapply(NEI.sub$Emissions, NEI.sub[, 2:3], sum)
NEI.Total <- as.data.frame.table(NEI.Total, stringsAsFactors = FALSE)
names(NEI.Total) <- c("Year", "Source.Type", "Emissions")
NEI.Total$Year <- as.integer(NEI.Total$Year)

# remove basic dataset
rm(NEI)

# init gr device
png(
     filename = "./plot3.png",
     width = 600,
     height = 480,
     units = "px"
)

library(ggplot2)

# plot
ggplot(NEI.Total,
       aes(x = Year,
           y = Emissions,
           col = Source.Type)) + 
     geom_line() + 
     ylab("Emissions (in tons)") + 
     ggtitle("The total PM2.5 emissions in the Baltimore City, Maryland")

dev.off()