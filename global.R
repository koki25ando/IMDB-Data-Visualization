##-------- Global Script ---------

## Package Loading
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)


## Data Loading
rating <- read.csv("https://s3-ap-southeast-2.amazonaws.com/koki25ando/IMDb/ratings.csv")

## Data Cleaning
rating$Title <- rating$Title %>% 
  str_replace_all("\xf4", "o")


## Category Data setting
Genres <- data.frame(rating$Genres)
Genres$rating.Genres <- Genres$rating.Genres %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(rating.Genres, sep = "\\$", into = c("genre1", "genre2"))
Genres$genre2 <- Genres$genre2 %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(genre2, sep = "\\$", into = c("genre2", "genre3"))
Genres$genre3 <- Genres$genre3 %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(genre3, sep = "\\$", into = c("genre3", "genre4"))
Genres$genre4 <- Genres$genre4 %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(genre4, sep = "\\$", into = c("genre4", "genre5"))
Genres$genre5 <- Genres$genre5 %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(genre5, sep = "\\$", into = c("genre5", "genre6"))
Genres$genre6 <- Genres$genre6 %>% 
  str_replace(",", "$")
Genres <- Genres %>% 
  separate(genre6, sep = "\\$", into = c("genre6", "genre7"))
Genres.tody <- Genres %>% 
  gather(key = "No", value = "Genre")