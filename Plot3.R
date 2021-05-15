library(data.table)
library(dplyr)
library(ggplot2)
#load data
NEI <- readRDS("./summarySCC_PM25.rds")

# subset data for Baltimore
Baltimore <- subset(NEI,fips == "24510")
# group the emissions by year
Baltimore <- group_by(Baltimore, type,year)
# sum the emissions by year
Baltimore_year <- summarize(Total_year = sum(Emissions),
                            Baltimore)

#plot3
png('plot3.png', width = 480, height = 480)
ggplot(Baltimore_year, aes(x = as.factor(year), y =Total_year, fill = type))+
  geom_bar(stat = "identity")+
  ylab(expression("Total PM"[2.5]*" emissions"))+
  xlab("Year")+
  guides(fill = FALSE)+
  scale_fill_manual(values =c("#8dd3c7", "#fdb462", "#bebada", "#fb8072"))+
  ggtitle(expression("Total PM"[2.5]*" emissions by year and type in Baltimore City"))+
  facet_grid(~type)+
  theme_light()
dev.off()
