##-------- Global Script ---------

## Package Loading
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)
library(lubridate)
library(rvest)
library(magick)

## Data Loading
rating <- read.csv("https://s3-ap-southeast-2.amazonaws.com/koki25ando/IMDb/ratings.csv")

## Data Cleaning
rating$Title <- rating$Title %>% 
  str_replace_all("\xf4", "o")
rating$Directors <- as.character(rating$Directors) %>% 
  str_replace("\xf4", "o")


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
Genres.tidy <- Genres %>% 
  gather(key = "No", value = "Genre")

## Category Select
genre.option <- Genres.tidy[!duplicated(Genres.tidy$Genre),]$Genre %>% 
  str_remove(" ")
genre.option <- genre.option[-18]

genre.option <- data.frame(genre.option) %>% 
  arrange(genre.option)

genre.option <- genre.option[!duplicated(genre.option$genre.option),]

## Date Reviewed
rating$Date.Rated <- as.Date(rating$Date.Rated)
rating <- rating %>% 
  mutate(Review_YearMonth = 
           paste0(year(Date.Rated), "-", str_pad(month(Date.Rated), pad = "0", width = 2)))

## Best Movies by year
year.range <- rating[!duplicated(rating$Year), ][,"Year"]
year.range <- data.frame(year.range) %>% 
  arrange(desc(year.range))

## Reviews of This Month
names(rating)[8] <- "Run_Mins"

## Directors' Columns
director <- data.frame(table(rating$Directors)) %>% 
  filter(Freq < 15)
names(director) <- c("Directors", "Num")
dr.rating <- merge(rating, director, by.x = "Directors", by.y = "Directors")
dr.rating$Directors <- as.character(dr.rating$Directors) %>% 
  str_replace("\xf4", "o")

