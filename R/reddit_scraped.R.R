# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

# Data Import and Cleaning
rstats_html <-read_html("https://old.reddit.com/r/rstats/")

post_title <- rstats_html %>%
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  html_elements(xpath = 'p[@class = "title"]/a') %>%
  html_text()

