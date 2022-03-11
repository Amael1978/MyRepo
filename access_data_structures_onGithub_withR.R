library(dplyr)
library(rvest)

# Simple Pull request bulk without read in

url <- "https://github.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/tree/master/Archiv"

GitHubRawFileList <- url %>%
  read_html() %>%
  html_nodes(xpath = '//*[@role="rowheader"]') %>%
  html_nodes('span a') %>%
  html_attr('href') %>%
  sub('blob/', '', .) %>%
  paste0('https://raw.githubusercontent.com', .) 

head(GitHubRawFileList)

GitHubRawFileListSubset <- GitHubRawFileList[grep("Deutschland_Impfquoten", GitHubRawFileList)]
head(GitHubRawFileListSubset)

for (val in GitHubRawFileListSubset) {
  # Simple Pull request read in
  x <- read.csv(url(val))
  head(x)
}

# Read Last Entry in List
xLast <- read.csv(url(GitHubRawFileListSubset[length(GitHubRawFileListSubset)]), encoding = "UTF-8")

# Plot

barplot(xLast$Impfungen_gesamt[-1], names.arg = xLast$Bundesland[-1])

# 3D Exploded Pie Chart
library(plotrix)
pie3D(xLast$Impfungen_gesamt[-1],labels=xLast$Bundesland[-1],explode=0.1,
      main="Pie Chart of vaccinations ")



