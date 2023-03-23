# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
library(rvest)

# Data Import and Cleaning

## Used fromJSON to read the json file into a list that can be manipulated in R
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")



