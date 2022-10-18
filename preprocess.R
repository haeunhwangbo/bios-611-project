library(tidyverse)


set_timeframe_stock <- function(df){
  df %>% filter(between(Date, as.Date('2020-01-01'), as.Date('2022-02-28')))
}

set_timeframe_twitter <- function(df){
  df %>% filter(between(date, as.Date('2020-01-01'), as.Date('2022-02-28')))
}

bitcoin <- read_csv(file.path(getwd(), "data/source_data/BTC-USD_daily.csv")) %>%
  rename(Adj_Close = `Adj Close`) %>% 
  set_timeframe_stock()
dogecoin <- read_csv(file.path(getwd(), "data/source_data/DOGE-USD.csv")) %>%
  rename(Adj_Close = `Adj Close`) %>% 
  set_timeframe_stock()
tesla <- read_csv(file.path(getwd(), "data/source_data/TSLA.csv")) %>% 
  rename(Adj_Close = `Adj Close`) %>%
  set_timeframe_stock()


twitter <- read_csv(paste0(getwd(), "/data/source_data/TweetsElonMusk.csv")) %>%
  set_timeframe_twitter() %>%
  select(-c(created_at, user_id, username, name, mentions, place, video, thumbnail, near, geo, source, translate, trans_src, trans_dest)) %>%
  filter(language=="en") %>%
  mutate(id=as.character(id), conversation_id=as.character(conversation_id))
  

# export pre-processed data
output_dir <- file.path(getwd(), "data/preprocessed")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

bitcoin %>% write_csv(file.path(output_dir, "BTC_preprocessed.csv"))
dogecoin %>% write_csv(file.path(output_dir, "DOGE_preprocessed.csv"))
tesla %>% write_csv(file.path(output_dir, "TSLA_preprocessed.csv"))
twitter %>% write_csv(file.path(output_dir, "elonmusk_twitter_preprocessed.csv"))

save(bitcoin, dogecoin, tesla, twitter, file=file.path(output_dir, "all_data.RData"))
