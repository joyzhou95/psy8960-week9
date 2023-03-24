# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
library(rlist)
library(tidyverse)

# Data Import and Cleaning

## Used fromJSON to read the json file into a list that can be manipulated in R
## Flattened data into non-nested structure to better convert it into dataframes later
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = T)

## First selected the data dataframe out of rstats_list 
## Then converted it into tibble format for later data manipulation, excluded the kind character from the final dataframe
rstats_original_tbl <- as_tibble(rstats_list[["data"]][["children"]][-1])

## Used pipelines to create new dataframe rstats_tbl with new variables    
rstats_tbl <- rstats_original_tbl %>% 
  ## Created post variable with the first 25 observations from the data.title variable, still specified 1:25 rows inside brackets to ensure scalability  
  mutate(post = data.title[1:25],
         ## Created the upvotes variable using data.ups 
         upvotes = data.ups[1:25],
         ## Created the comments variabel using data.num_comments
         comments = data.num_comments[1:25]) %>%
  ## Selected only the three variables we need
  select(post, upvotes, comments) %>%
  ## Created a dataframe using the three variables 
  as_tibble()
  
# Visualization
rstats_tbl %>%
  ggplot(aes(upvotes, comments)) +
  geom_point()




