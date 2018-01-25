setwd("D:/coursera/Exploratory Data Analysis/EDA Course project/")

# download and unzip assignment data from web resource
source("LoadData.R")

## reading files
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# QUESTION 6
# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles County, California
# Which city has seen greater changes over time in motor vehicle emissions?

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

# filter motor vehicle sources in Baltimore and LA
NEI <- NEI %>% inner_join(SCC, by = "SCC") %>% filter(fips %in% c("24510", "06037"))
NEI <- NEI %>% filter(grepl("motor", Short.Name, ignore.case = TRUE)) %>%
         select(-c(SCC, Short.Name))

rm(SCC)

# calculate total emissions by year and fips
NEI.Total <- tapply(NEI$Emissions, NEI[, 2:3], sum)
NEI.Total <- as.data.frame.table(NEI.Total, stringsAsFactors = FALSE)
names(NEI.Total) <- c("Year", "FIPS", "Emissions")
NEI.Total$Year <- as.integer(NEI.Total$Year)

# remove basic dataset
rm(NEI)

# init gr device
png(
     filename = "./plot6.png",
     width = 600,
     height = 480,
     units = "px"
)

# plot to file
ggplot(NEI.Total, aes(Year, Emissions, col = FIPS)) +
     geom_line() +
     ylab("Emissions (in tons)") +
     ggtitle("The total PM2.5 emissions from motor vehicle sources in the Baltimore and Los Angeles") +
     scale_color_manual(values = c("red", "blue"),
                        label = c("Los Angeles", "Baltimore"))

dev.off()