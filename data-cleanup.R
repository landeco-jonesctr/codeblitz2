library(tidyverse)
# quickly summarizing and cleaning up LTM Data
trees = read_csv('Trees Report.csv') #downloaded from Oracle database
trunks = read_csv('Trunks Report.csv') #downloaded from Oracle database

#format the dates so that we can extract the year %Y
trees$year = format(as.Date(trees$Plotdate, tryFormats = '%m-%d-%Y'), '%Y')
trunks$year = format(as.Date(trunks$Plotdate, tryFormats = '%m-%d-%Y'), '%Y')

# make a unique plot/year/tree identifier
trees = mutate(trees, uniqueId = paste0(`Plot Id`, '_', Treenumber, '_', year))
trunks = mutate(trunks, uniqeId = paste0(`Plot Id`, '_', Treenumber, '_', year))

head(trees)
head(trunks)

# Merge and cleanup data
all_dat = merge(trees, trunks)
# mark all snags as T/F
all_dat$Snag[all_dat$Snag=='NO DATA'] = NA
all_dat = filter(all_dat, Subplot!=2)
all_dat$Snag = !is.na(all_dat$Snag)
# Average two DBH measurements
all_dat$dbh = apply(all_dat[, c('Dbhone', 'Dbhtwo')], 1, mean, na.rm=TRUE)
#clean up column names, no spaces, camelCase
all_dat = mutate(all_dat, species = Species, interval = `Sample Inter`, plotDate = Plotdate, subplot=Subplot, treeNumber=Treenumber, plotId = `Plot Id`, utmX = `Gps Utm X`, utmY = `Gps Utm Y`, snag = Snag)
all_dat = select(all_dat, uniqueId, `plotId`, `treeNumber`, year, species, dbh, snag, `interval`, `utmX`,  `utmY`, plotDate)

#write to codeblitz folder
write_csv(all_dat, 'R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv')


library(tidyverse)
cc = read_csv('C:/Users/jeffery.cannon/Downloads/Plot Visits.csv')
cc = select(cc, Plotdate, `Plot Id`, Canopy) %>%
  mutate(plotDate = Plotdate, plotId = `Plot Id`, canopy = Canopy) %>%
  select(plotDate, plotId, canopy) %>%
  mutate(year = substr(plotDate, nchar(plotDate)-3, nchar(plotDate))) %>%
  filter(year > 2012)

cc = cc %>% select(!year)

write_csv(cc, 'R:/landscape_ecology/codeblitz/codeblitz2/canopy-data.csv')



