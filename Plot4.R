library(data.table)
library(dplyr)
#load data
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

# select the sources related to fuel
SCC_coal <- SCC[grep("Fuel Comb.*Coal", SCC$EI.Sector),]
SCC_coal <- unique(SCC_coal$SCC)
# select the sources from NEI dataset
NEI_coal <- subset(NEI, SCC %in% SCC_coal)
# group by type and year
NEI_coal <- group_by(NEI_coal, type, year)
# sum the total emissions by type and year
NEI_coal <- summarize(Total_year = sum(Emissions),
                      NEI_coal)
# group by year
NEI_coal_tot <- group_by(NEI_coal,year) 
# sum emissions by year and add column type
NEI_coal_tot <- summarize(Total_year = sum(Total_year),
                          NEI_coal_tot)%>% mutate(type = "TOTAL")
# select specific columns
NEI_coal <- NEI_coal %>% select(Total_year, type, year)
NEI_coal <- bind_rows(NEI_coal, NEI_coal_tot)

#plot 4
png('plot4.png', width = 480, height = 480)
ggplot(NEI_coal, aes(x = as.factor(year), y =Total_year, fill = type))+
  geom_bar(stat = "identity")+
  ylab(expression("Total PM"[2.5]*" emissions"))+
  xlab("Year")+
  guides(fill = FALSE)+
  scale_fill_manual(values =c("#8dd3c7", "#fdb462", "#bebada", "#fb8072"))+
  ggtitle(expression("Total PM"[2.5]*" emissions by year and type in the United States"))+
  facet_grid(~type)+
  theme_light()
dev.off()
