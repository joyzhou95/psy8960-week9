# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
library(rlist)
library(tidyverse)

# Data Import and Cleaning

## Used fromJSON to read the json file into a list that can be manipulated in R
##Flattened data into non-nested structure to better convert it into dataframes later
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = T)

##First selected the data dataframe out of rstats_list 
##Then converted it into the dataframe for later data manipulation 
rstats_original_tbl <- as.data.frame(rstats_list[["data"]][["children"]][-1])
  



