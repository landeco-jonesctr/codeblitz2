#Calculating basal area

#loading libraries
library(dplyr)

#loading data
ltm_df <- read.csv("ltm-data.csv")
dbh <- c(10, 20, -50, NA, 0)


#ba function
dbh_machine <- function(dbh){
  dbh <- ifelse(dbh >= 0, dbh, NA)
  ba_tree <- (dbh / 200)^2 * pi #m2
  return(ba_tree)
}
dbh_machine(dbh)


