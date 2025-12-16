
# Team_room1 (Leah, Carly, Tristen, Jingting)

# GROUP WORK 1: Function calculating basal area --------------------------------

#loading libraries
library(dplyr)
library(ggplot2)

#ba function
dbh <- c(10, 20, NA, 0) #test data

ba_machine <- function(dbh){
  ba_tree <- (dbh / 200)^2 * pi #BA of each tree (m2)
  ba_no_na <- as.vector(na.omit(ba_tree)) # BA of each tree, removing NAs
  ba_tree <- ba_no_na / 0.10 #0.1 ha LTM plot size
  #ba_plot <- sum(ba_no_na) / 0.10 #0.10 ha LTM plots; BA for entire plot
  return(ba_tree) # m2/ha
}
ba <- ba_machine(dbh)


# GROUP WORK 2: Main Dataset ---------------------------------------------------
# goal: calculate BA for all plots by year

#loading data
setwd("R:/landscape_ecology/codeblitz/codeblitz2")
ltm_data <- read.csv("ltm-data.csv")
View(ltm_data)

#calculate total BA for all plots by year
ltm_data <- ltm_data %>% mutate(ba = ba_machine(dbh)) #adding tree BA to dataset
plot_ba_by_yr <- ltm_data %>% group_by(year) %>% summarize(tot_ba = sum(ba)) #total BA by year

#graph of avg BA by year
avg_yr_ba <- ltm_data %>% group_by(year) %>% summarize(mean_ba = mean(ba))
ggplot(data = avg_yr_ba, aes(x = year, y = mean_ba)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(breaks = seq(from = 0.5, to = 1, by = 0.05), limits = c(0.6, 1)) +
  scale_x_continuous(breaks = seq(from = 2000, to = 2025, by = 2)) +
  labs(y = "Mean Basal Area", x = "Year", title = "LTM Plots: Average basal area for all plots over time") +
  theme_bw()

#graph of BA by year for the 5 major species
species_list <- unique(ltm_data$species)
species_count <- vector()
for(i in 1:length(species_list)){
  #i <- 2
  sp <- species_list[i]
  sp_count <- sum(ltm_data$species == sp)
  species_count <- c(species_count, sp_count)
}
sp_count_df <- data.frame(species_list, species_count)
sp_count_df <- arrange(sp_count_df, desc(species_count)) #ranked list of species
top_sp_list <- head(sp_count_df, 5)$species_list #top 5 species

#finally graphing
top_sp_df <- ltm_data %>% filter(species == "PIPA" | species == "PIEL" | 
                                   species == "QUVI" | species == "QUNI" | 
                                   species == "QULA")
avg_yrsp_ba <- top_sp_df %>% group_by(year, species) %>% summarize(mean_ba = mean(ba))
ggplot(data = avg_yrsp_ba, aes(x = year, y = mean_ba)) +
  geom_point(aes(col = species)) +
  geom_line(aes(col = species)) +
  facet_wrap(~species, ncol = 1) +
  scale_y_continuous(breaks = seq(from = 0, to = 3, by = 0.5), limits = c(0, 3)) +
  scale_x_continuous(breaks = seq(from = 2000, to = 2025, by = 2)) +
  labs(y = "Mean Basal Area", x = "Year", title = "LTM Plots: Average basal area of top 5 species in all plot over time") +
  theme_bw()









