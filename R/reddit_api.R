# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(jsonlite)
library(tidyverse)

# Data Import and Cleaning

## Used fromJSON to read the json file into a list that can be manipulated in R
## Flattened data into non-nested structure to better convert it into dataframes later
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = T)

## First selected the data dataframe out of rstats_list, which is under children
## Then converted it into tibble format for later data manipulation
rstats_original_tbl <- as_tibble(rstats_list[["data"]][["children"]])

## Used pipelines to create a new dataframe "rstats_tbl" that contains new variables    
rstats_tbl <- rstats_original_tbl %>% 
  ## Created the post variable using the data.title variable
  mutate(post = data.title,
         ## Created the upvotes variable using data.ups 
         upvotes = data.ups,
         ## Created the comments variabel using data.num_comments
         comments = data.num_comments) %>%
  ## Selected only the three variables we need
  select(post, upvotes, comments) %>%
  ## Created a dataframe using the three variables 
  as_tibble()
  
# Visualization
## Used rstats_tbl to create a scatterplot 
rstats_tbl %>%
  ## Set upvotes to be on the x-axis and comments on the y axis
  ggplot(aes(upvotes, comments)) +
  ## Added the layer of scatterplot 
  geom_point() +
  ## Added a title for the plot
  labs(title = "The Relationship between the Number of Upvotes and Comments")

# Analysis 
## Calulated correlation statistics between upvotes and comments using cor.test
cor <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
## Displayed the correlation coefficient and p-value by selecting them from the output 
cor$estimate
cor$p.value

## Formatted the correlation values so that it only displays two decimal places and then converted it to numeric values 
cor_value <- as.numeric(formatC(cor$estimate, format = "f", digits = 2))

## Used str_remove function to remove the leading (first) 0 in the number 
cor_value <- str_remove(string = cor_value, pattern = "^0")

## Repeated the above steps for p-value
cor_pvalue <- as.numeric(formatC(cor$p.value, format = "f", digits = 2))
cor_pvalue <- str_remove(string = cor_pvalue, pattern = "^0")


# Publication
## Printed the text using paste to combine the text and codes together so the values can be shown dynamically, also wrote if function so that the interpretation will change based on the p-value
## print(paste("The correlation between upvotes and comments was r(", cor$parameter, ") =", cor_value,", p =", cor_pvalue, ".","This test", if(cor_pvalue < 0.05){"was"}else{"was not"}, "statistically significant."))


