#loading libraries
install.packages("tidyverse")
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
calc_qmd(dbh)

#calculating qmd by year

qmd_by_yr <- ltm %>% group_by(year, plotId) %>% 
  summarise(qmd = calc_qmd(dbh))
qmd_by_yr_filtered <- qmd_by_yr %>%
  filter(!is.na(qmd))

avg_by_yr <- qmd_by_yr_filtered %>% group_by(year) %>% summarise(avgqmd = mean(qmd)) 

#graphing avg qmd by year for all plots

ggplot(data = qmd, aes(x = year, y = mean_qmd)) +
  geom_point() +
  scale_x_continuous(breaks = seq(from = 2000, to = 2025, by = 2)) +
  theme_bw()

ltm_summary %>% ggplot(aes(qmd))+
  geom_histogram()+
  facet_wrap(vars(year))
