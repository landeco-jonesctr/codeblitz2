#loading libraries
library(dplyr)
library(tidyverse)
library(ggplot2)

#loading data
ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")

# QMD Function
calc_qmd <- function(dbh,dbh_threshold=10) {
  if(!is.numeric(dbh)) warning("dbh must be numeric.")
  
  dbh_cm <- dbh[!is.na(dbh) & dbh>=dbh_threshold] #might not work!! in progress
  qmd <- sqrt(mean(dbh_cm^2))
  
  return(qmd)
}


#graphing avg qmd by year for all plots
qmd_by_yr <- ltm %>% group_by(year, plotId) %>% 
  summarise(qmd = calc_qmd(dbh))

qmd <- qmd_by_yr %>% group_by(year) %>% summarise(mean_qmd = mean(qmd))
ggplot(data = qmd, aes(x = year, y = mean_qmd)) +
  geom_point() +
  scale_x_continuous(breaks = seq(from = 2000, to = 2025, by = 2)) +
  theme_bw()



ltm_summary %>% ggplot(aes(qmd))+
  geom_histogram()+
  facet_wrap(vars(year))
