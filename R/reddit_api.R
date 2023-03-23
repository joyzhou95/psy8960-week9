# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
library(rlist)
library(tidyverse)

# Data Import and Cleaning

## Used fromJSON to read the json file into a list that can be manipulated in R
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")

##Used list.select to select only the data list under children
##Needed to wrap rstats_list with list() to create a list environment for list.select to work
rstats_original_tbl <- list.select(list(rstats_list), data$children$data)





