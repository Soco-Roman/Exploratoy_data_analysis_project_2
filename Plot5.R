library(data.table)
library(dplyr)
#load data
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

# select the sources related to motor vehicles
SCC_vehicles <- SCC[grep("Mobile.*Vehicles", SCC$EI.Sector),]
SCC_vehicles_ <- unique(SCC_vehicles$SCC)
# select the sources from NEI dataset
NEI_vehicles <- subset(NEI, SCC %in% SCC_vehicles_)
NEI_vehicles <- subset(NEI_vehicles, fips == "24510")

# join the descriptions and codes
NEI_vehicles <- merge(x = NEI_vehicles, 
                      y = SCC_vehicles[,c("SCC", "SCC.Level.Two","SCC.Level.Three")], 
                      by = "SCC")
# group by type and year
NEI_vehicles <- group_by(NEI_vehicles, year, SCC.Level.Two, SCC.Level.Three)
# sum the total emissions by type and year
NEI_vehicles <- summarize(Total_year = sum(Emissions),
                      NEI_vehicles)
# group by year
NEI_vehicles_tot <- group_by(NEI_vehicles,year) 
# sum emissions by year and add column level
NEI_vehicles_tot <- summarize(Total_year = sum(Total_year),
                          NEI_vehicles_tot)%>% mutate(SCC.Level.Two = "TOTAL")

NEI_vehicles <- bind_rows(NEI_vehicles, NEI_vehicles_tot)

#plot 5
png('plot5.png', width = 480, height = 480)
ggplot(NEI_vehicles, aes(x = as.factor(year), y =Total_year, fill = SCC.Level.Two))+
  geom_bar(stat = "identity")+
  ylab(expression("Total PM"[2.5]*" emissions"))+
  xlab("Year")+
  guides(fill = FALSE)+
  scale_fill_manual(values =c("#8dd3c7", "#fdb462", "#bebada", "#fb8072"))+
  ggtitle(expression("Total PM"[2.5]*" emissions by year and motor vehicle sources in Baltimore"))+
  facet_grid(~SCC.Level.Two)+
  theme_light()
dev.off()
