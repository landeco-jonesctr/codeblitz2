
### Codeblitz2 Exercise
### Group 1 - Nicole, Jingting, Tanner


library(dplyr)

## Task - Species Lookup

sp_list <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/veglist_2006.csv")

### new codes to add to sp_list
code <- c("PIST", "PISN", "HWST," "HWSN", "JUST", "JUSN")
commonName <- c("pine stump", "pine snag", "hardwood stump", "hardwood snag", "cedar stump", "cedar snag")

convert_species <- function(codes, sp_list) {
  # make lookup case-insensitive
  sp_list$code <- tolower(sp_list$code)
  codes_lower <- tolower(codes)
  
  # match codes to names
  sp_list$commonName[match(codes_lower, sp_list$code)]
}

#checking does it work?
sp_codes <- c("ACRU", "ACSA")
convert_species(sp_codes, sp_list)
