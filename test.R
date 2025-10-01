library(tidyverse)
library(dplyr)
library(ggplot2)

ltm <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")

unique(ltm$species)
unique(unique(ltm$plotId))
length(unique(ltm$year))
unique(ltm$interval)

# Species lookup
splist <- c(
  PIPA = "Pinus palustris",
  PITA = "Pinus taeda",
  QUST = "Quercus stellata",
  QUNI = "Quercus nigra",
  QUGE = "Quercus geminata",
  QUMI = "Quercus michauxii",
  QUFA = "Quercus falcata"
)

lookup_species <- function(species, list = splist) {
  if(!is.character(species)) stop("Input must be a character vector.")
  
  species_upper <- toupper(species)
  names(list) <- toupper(names(list))
  spnames <- list[species_upper]
  
  missing <- is.na(spnames)
  if(any(missing)){
    warning("Some codes not found: ", paste(unique(species[missing]),collapse=", "))
  }
  
  return(spnames)
}

ltm2 <- ltm %>% mutate(spnames=lookup_species(species))

# Basal area
calc_ba <- function(dbh, plot_ha=0.1) {
  if(!is.numeric(dbh)) stop("dbh must be numeric.")
  
  dbh_cm <- dbh[!is.na(dbh) & dbh>=10]
  treeba_m2 <- pi*(dbh_cm/200)^2
  ba_m2ha <- sum(treeba_m2)/plot_ha
  
  return(ba_m2ha)
}

# QMD
calc_qmd <- function(dbh) {
  if(!is.numeric(dbh)) stop("dbh must be numeric.")
  
  dbh_cm <- dbh[!is.na(dbh) & dbh>=10]
  qmd <- sqrt(mean(dbh_cm^2))
  
  return(qmd)
}

ltm_summary <- ltm %>% group_by(plotId,year) %>% 
  summarise(ba_m2ha=calc_ba(dbh),
            stand_density=length(dbh) / 0.1,
            qmd=calc_qmd(dbh))

ltm_summary %>% ggplot(aes(x=year,y=ba_m2ha))+
  geom_boxplot(aes(group=year))

# Canopy cover
avg_canopy <- function(readings) {
  # input: numeric vector of 4 readings
  # output: average canopy cover (%)
}