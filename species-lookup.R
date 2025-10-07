
### Codeblitz2 Exercise
### Group 1 - Nicole, Jingting, Tanner


library(dplyr)

## Task - Species Lookup

sp_list_raw <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/veglist_2006.csv")

### new codes to add to sp_list
newcodes <- c("PIST", "PISN", "HWST", "HWSN", "JUST", "JUSN")
newnames <- c("pine stump", "pine snag", "hardwood stump", "hardwood snag", "cedar stump", "cedar snag")

new_rows <- data.frame(code = newcodes, commonName= newnames,
                       family = NA, genus = NA, species = NA, sub = NA, status = NA,
                       stringsAsFactors = FALSE)

sp_list <- rbind(sp_list_raw, new_rows)

convert_species <- function(codes, sp_list) {
  # make lookup case-insensitive
  sp_list$code <- tolower(sp_list$code)
  codes_lower <- tolower(codes)
  
  # match codes to names
  sp_list$commonName[match(codes_lower, sp_list$code)]
}

#checking does it work?
sp_codes <- c("ACRU", "ACSA", "PISN")
convert_species(sp_codes, sp_list)
