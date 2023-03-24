# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(rvest)


# Data Import and Cleaning

rstats_html <- read_html("https://old.reddit.com/r/rstats/")


