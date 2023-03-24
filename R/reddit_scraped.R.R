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

upvotes <- rstats_html %>%
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  html_elements(xpath = '..//preceding-sibling::div[@class = "midcol unvoted"]') %>%
  html_elements(xpath = 'div[@class = "score unvoted"]') %>%
  html_text()

comments <- rstats_html %>%
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  html_elements(xpath = '..//li[@class = "first"]/a') %>%
  html_text() %>%
  str_extract("\\d") %>%
  as.numeric() %>%
  replace_na(0)

rstats_tbl <-tibble(post = post_title, upvotes = upvotes, comments = comments)
                       

