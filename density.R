data <- read.csv("R:/landscape_ecology/codeblitz/codeblitz2/ltm-data.csv")
data <- data %>%
  select(plotId, treeNumber, year)
data <- data %>%
  rename(Year = year) %>%
  rename(Plot = plotId)
data
data <- group_by(data, Plot, Year)
density_data <- summarize(data, Density=length(treeNumber)/0.1)
print(density_data)

density_sorted <- group_by(density_data, Year)
density_sorted

density_output <- summarize(density_sorted, Density_Mean = mean(Density))
density_output

ggplot(density_output, aes(x = Year, y = Density_Mean)) + geom_point() + geom_line() + theme_bw()
