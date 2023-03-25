# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

# Data Import and Cleaning
rstats_html <-read_html("https://old.reddit.com/r/rstats/")

## Scrapped the post titles from rstats_html and stored it into an object called post_title  
post_title <- rstats_html %>%
  ## To screen out advertisement posts, I only selected the posts that are "submitted" by users rather than "promoted"
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  ## Selected the title class where the titles are stored in
  html_elements(xpath = 'p[@class = "title"]/a') %>%
  ## Extracted the title text from the class
  html_text()

## Scrapped the number of upvotes per post from rstats_html and stored it into an object called upvotes  
upvotes <- rstats_html %>%
  ## Same as above, # To screen out advertisement posts, I only selected the posts that are "submitted" by users rather than "promoted"
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  ## Went up to the parent (entry unvoted) of the div class that "submitted" was stored in (top matter), and then selected the preceding sibling (midcol unvoted) of the parent  
  html_elements(xpath = '..//preceding-sibling::div[@class = "midcol unvoted"]') %>%
  ## Selected the upvotes from the midcol unvoted div class
  html_elements(xpath = 'div[@class = "score unvoted"]') %>%
  ## Extracted the upvotes characters from the score unvoted class
  html_text() %>%
  ## Converted them into numeric values for later analyses
  as.numeric() %>%
  ## Replace NA with 0 
  replace_na(0)

## Scrapped the number of comments per post from rstats_html and stored it into an object called comments 
comments <- rstats_html %>%
  ## Same as above, # To screen out advertisement posts, I only selected the posts that are "submitted" by users rather than "promoted"
  html_elements(xpath = '//div[p[text() = "submitted "]]') %>%
  ## Went up to the parent (entry unvoted) of the div class that "submitted" was stored in (top matter), then selected the "first" class that comments are stored in 
  html_elements(xpath = '..//li[@class = "first"]/a') %>%
  ## Extracted only the comments text from the above class
  html_text() %>%
  ## Extracted only the number of comments from the comments texts 
  str_extract("\\d+") %>%
  ## Converted them into numeric values for later analyses
  as.numeric() %>%
  ## Replace NA with 0
  replace_na(0)

## Created the rstats_tbl dataframe using the variables created above, and named them based on instructions
rstats_tbl <-tibble(post = post_title, upvotes = upvotes, comments = comments)
                       
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


# Publication
## print(paste("The correlation between upvotes and comments was r(", cor$parameter ,  ") =", cor_value,",p =", cor_pvalue, ".","This test was statistically significant."))

## Formatted the correlation values so that it only displays two decimal places
cor_value <- formatC(cor$estimate, format = "f", digits = 2)

## Used str match and replace funtions to remove the leading 0 by identifying the pattern and then replace it with an empty string
cor_value <- str_replace(string = cor_value, pattern = str_match(cor_value, pattern = '(0)\\.')[,2], replacement = "")

## Repeated the above steps for p-value
cor_pvalue <- formatC(cor$p.value, format = "f", digits = 2)
cor_pvalue <- str_replace(string = cor_pvalue, pattern = str_match(cor_pvalue, pattern = '(0)\\.')[,2], replacement = "")


