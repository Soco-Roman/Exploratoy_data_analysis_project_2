library(data.table)
library(dplyr)
#load data
NEI <- readRDS("./summarySCC_PM25.rds")

# subset data for Baltimore
Baltimore <- subset(NEI,fips == "24510")
# group the emissions by year
Baltimore <- group_by(Baltimore, year)
# sum the emissions by year
Baltimore_year <- summarize(Total_year = sum(Emissions),
                      Baltimore)
# change the units
Baltimore_year$Total_year_k <- Baltimore_year$Total_year/1000

#plot2
png('plot2.png', width = 480, height = 480)
plot(x = Baltimore_year$year, 
     y = Baltimore_year$Total_year_k,
     type = "l",
     xlab = "Year",
     ylab = expression("Total PM"[2.5]*" emissions (K)"),
     main = expression("Total PM"[2.5]*" emissions by year in Baltimore City"))
dev.off()
