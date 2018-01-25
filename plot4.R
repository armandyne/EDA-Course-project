setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# QUESTION 4
# Across the United States, how have emissions from 
# coal combustion-related sources changed from 1999–2008?

# look at our data
head(SCC)
head(NEI)
dim(NEI)
dim(SCC)
summary(NEI)
str(SCC)
str(NEI)
summary(SCC)

library(dplyr)

NEI <- select(NEI, SCC, Emissions, year)
SCC <- select(SCC, SCC, Short.Name)

# filter coal related sources  
NEI <- NEI %>% inner_join(SCC, by = "SCC") 
NEI <- NEI %>% filter(grepl("coal", Short.Name, ignore.case = TRUE)) %>% 
          select(-c(SCC,Short.Name))

rm(SCC)

# calculate total emissions by year
NEI.Total <- tapply(NEI$Emissions, NEI[, 2], sum)
NEI.Total <- as.data.frame.table(NEI.Total, stringsAsFactors = FALSE)
names(NEI.Total) <- c("Year", "Emissions")
NEI.Total$Emissions <- NEI.Total$Emissions / 1000
NEI.Total$Year <- as.integer(NEI.Total$Year)

# remove basic dataset
rm(NEI)

# init gr device
png(
     filename = "./plot4.png",
     width = 600,
     height = 480,
     units = "px"
)

# plot to file
ggplot(NEI.Total, aes(Year, Emissions)) + 
       geom_line() + 
       ylab("Emissions (in thousand tons)") + 
       ggtitle("The total PM2.5 emissions From Coal Combustion-related \n Sources in the United States")

dev.off()