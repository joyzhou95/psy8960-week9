# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
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
## Used rstats_tbl to create a scatterplot 
rstats_tbl %>%
  ## Set upvotes to be on the x-axis and comments on the y axis
  ggplot(aes(upvotes, comments)) +
  ## Add the layer of scatterplot 
  geom_point()

# Analysis 
## Calulated correlation statistics between upvotes and comments using cor.test
cor <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
## Displayed the correlation coefficient and p-value by selecting them from the output 
cor$estimate
cor$p.value


# Publication
## print(paste("The correlation between upvotes and comments was r(", cor$parameter ,  ") =", cor_value,",p =", cor_pvalue, ".","This test was statistically significant."))

## Formatted the correlation values so that it only displays two decimal places
cor_value <- formatC(cor$estimate, format = "f", digits = 2)

## Used str match and replace funtions to remove the leading 0 by identifying the pattern and then replace it with an empty string
cor_value <- str_replace(string = cor_value, pattern = str_match(cor_value, pattern = '(0)\\.')[,2], replacement = "")

## Repeated the above steps for p-value
cor_pvalue <- formatC(cor$p.value, format = "f", digits = 2)
cor_pvalue <- str_replace(string = cor_pvalue, pattern = str_match(cor_pvalue, pattern = '(0)\\.')[,2], replacement = "")
  




