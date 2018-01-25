setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# QUESTION 5
# How have emissions from motor vehicle sources changed 
# from 1999–2008 in Baltimore City?

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

NEI <- select(NEI, SCC, Emissions, year, fips)
SCC <- select(SCC, SCC, Short.Name)

# filter motor vehicle sources in Baltimore
NEI <- NEI %>% inner_join(SCC, by = "SCC") %>% filter(fips == "24510")
NEI <- NEI %>% filter(grepl("motor", Short.Name, ignore.case = TRUE)) %>% 
         select(-c(SCC, fips, Short.Name))

rm(SCC)

# calculate total emissions by year
NEI.Total <- tapply(NEI$Emissions, NEI[, 2], sum)
NEI.Total <- as.data.frame.table(NEI.Total, stringsAsFactors = FALSE)
names(NEI.Total) <- c("Year", "Emissions")
NEI.Total$Year <- as.integer(NEI.Total$Year)

# remove basic dataset
rm(NEI)

# init gr device
png(
     filename = "./plot5.png",
     width = 600,
     height = 480,
     units = "px"
)

# plot to file
ggplot(NEI.Total, aes(Year, Emissions)) + 
     geom_line() + 
     ylab("Emissions (in tons)") + 
     ggtitle("The total PM2.5 emissions from motor vehicle sources in the Baltimore") + 
     geom_point()

dev.off()