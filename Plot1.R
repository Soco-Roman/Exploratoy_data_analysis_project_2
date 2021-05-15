setwd("D:/Course/Data/4.Project")
library(data.table)
library(dplyr)
#load data
NEI <- readRDS("./summarySCC_PM25.rds")

# subset the years
NEI_year <- subset(NEI, year == 1999 | year == 2002 | year == 2005 | year == 2008)
# group the emissions by year
NEI_year <- group_by(NEI_year, year)
# sum the emissions by year
NEI_year <- summarize(Total_year = sum(Emissions),
                      NEI_year)
# change the units into tons
NEI_year$Total_year_ton <- NEI_year$Total_year/1000000

#plot1
png('plot1.png', width = 480, height = 480)
barplot(height = NEI_year$Total_year_ton, 
        names.arg = NEI_year$year,
        xlab = "Year",
        ylab = expression("Total PM"[2.5]*" emissions (Ton)"),
        main = expression("Total PM"[2.5]*" emissions by year in the United States"))
dev.off()
