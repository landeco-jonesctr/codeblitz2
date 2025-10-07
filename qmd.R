library(dplyr)
library(tidyverse)
library(ggplot2)

ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")

# QMD
calc_qmd <- function(dbh) {
  if(!is.numeric(dbh)) stop("dbh must be numeric.")
  
  dbh_cm <- dbh[!is.na(dbh) & dbh>=10]
  qmd <- sqrt(mean(dbh_cm^2))
  
  return(qmd)
}

ltm_summary <- ltm %>% group_by(plotId,year) %>% 
  summarise(qmd=calc_qmd(dbh))

ltm_summary %>% ggplot(aes(qmd))+
  geom_histogram()+
  facet_wrap(vars(year))