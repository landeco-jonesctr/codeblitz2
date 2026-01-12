#loading libraries

library(dplyr)
library(tidyverse)
library(ggplot2)

#loading data
ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")

# QMD Function
calc_qmd <- function(dbh,dbh_threshold=10) {
  if(!is.numeric(dbh)) warning("dbh must be numeric.")
  
  dbh_cm <- dbh[!is.na(dbh)]
  dbh_cm <- dbh_cm[dbh_cm >= dbh_threshold]
  qmd <- sqrt(mean(dbh_cm^2))
  
  return(qmd)
}

#calculating qmd by year
ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")
qmd_by_yr <- ltm %>% group_by(year, plotId) %>% 
  summarise(qmd = calc_qmd(dbh))
qmd_by_yr_filtered <- qmd_by_yr %>%
  filter(!is.na(qmd))

avg_by_yr <- qmd_by_yr_filtered %>% group_by(year) %>% summarise(avgqmd = mean(qmd)) 

#calculating density by year
ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")
ltm <- ltm %>%
  select(plotId, treeNumber, year)
ltm <- ltm %>%
  rename(Year = year) %>%
  rename(Plot = plotId)
ltm
ltm <- group_by(ltm, Plot, Year)
density_data <- summarize(ltm, Density=length(treeNumber)/0.1)
print(density_data)

density_sorted <- group_by(density_data, Year)
density_sorted

density_output <- summarize(density_sorted, Density_Mean = mean(Density))
view(density_output)

#ba machine by year
ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")
ba_machine <- function(dbh){
  ba_tree <- (dbh / 200)^2 * pi #BA of each tree (m2)
  ba_no_na <- as.vector(na.omit(ba_tree)) # BA of each tree, removing NAs
  ba_tree <- ba_no_na / 0.10 #0.1 ha LTM plot size
  #ba_plot <- sum(ba_no_na) / 0.10 #0.10 ha LTM plots; BA for entire plot
  return(ba_tree) # m2/ha
}

#calculate total BA for all plots by year
ltm <- ltm %>% mutate(ba = ba_machine(dbh)) #adding tree BA to dataset
plot_ba_by_yr <- ltm %>% group_by(year) %>% summarize(tot_ba = sum(ba)) #total BA by year



density_output
avg_by_yr
plot_ba_by_yr
avg_by_yr <- avg_by_yr %>%
  rename("Year" = "year")
plot_ba_by_yr <- plot_ba_by_yr %>%
  rename("Year" = "year")
combined_1 <- density_output %>%
  left_join(avg_by_yr, by = "Year")
combined_table <- combined_1 %>%
  left_join(plot_ba_by_yr, by = "Year")
combined_table <- combined_table %>%
  rename("Density" = "Density_Mean") %>%
  rename("QMD" = "avgqmd") %>%
  rename("BA" = "tot_ba")
combined_table