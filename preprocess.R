library(tidyverse)
library(tidytext)

set_timeframe <- function(df){
  df %>% filter(between(Date, as.Date('2021-01-01'), as.Date('2021-12-31')))
}


# References:
# https://jtr13.github.io/cc21/twitter-sentiment-analysis-in-r.html
# https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/text-mining-twitter-data-intro-r/

## pre-processing text:
clean_text = function(x)
{
  # convert to lower case
  x = tolower(x)
  # remove &amp
  
  # remove rt
  x = gsub("rt", "", x)
  # remove at
  #x = gsub("@\\w+", "", x)
  # remove punctuation
  x = gsub("[[:punct:]]", "", x)
  # remove numbers
  #x = gsub("[[:digit:]]", "", x)
  # remove links http
  x = gsub("http\\w+", "", x)
  # remove tabs
  x = gsub("[ |\t]{2,}", "", x)
  # remove blank spaces at the beginning
  x = gsub("^ ", "", x)
  # remove blank spaces at the end
  x = gsub(" $", "", x)
  # some other cleaning text
  x = gsub('amp', '', x)
  x = gsub('https://','',x)
  x = gsub('http://','',x)
  x = gsub('[^[:graph:]]', ' ',x)
  x = gsub('[[:punct:]]', '', x)
  x = gsub('[[:cntrl:]]', '', x)
  x = gsub('\\d+', '', x)
  
  x = str_replace_all(x,"[^[:graph:]]", " ")
  return(x)
}

# stocks
bitcoin <- read_csv(file.path(getwd(), "data/source_data/BTC-USD_daily.csv")) %>%
  rename(Adj_Close = `Adj Close`) %>% 
  set_timeframe()
dogecoin <- read_csv(file.path(getwd(), "data/source_data/DOGE-USD.csv")) %>%
  rename(Adj_Close = `Adj Close`) %>% 
  set_timeframe()
tesla <- read_csv(file.path(getwd(), "data/source_data/TSLA.csv")) %>% 
  rename(Adj_Close = `Adj Close`) %>%
  set_timeframe()

# Garman & Klass (1980) Intraday Volatility
add_intraday_volatility <- function(df){
  df %>% mutate(Intraday_Volatility = 0.5 * log(High/Low)**2 - 2 * (log(2) - 1) * (log(Close/Open))**2)
}

add_interday_change <- function(df){
  df %>% mutate(Interday_Change = 100 * (Close - lag(Close)) / lag(Close))
}

bitcoin <- bitcoin %>% add_intraday_volatility() %>% add_interday_change()
dogecoin <- dogecoin %>% add_intraday_volatility() %>% add_interday_change()
tesla <- tesla %>% add_intraday_volatility() %>% add_interday_change()

# twitter

twitter2021 <- read_csv(paste0(getwd(), "/data/source_data/Elon2021.csv"))
twitter2021 <- twitter2021[2:ncol(twitter2021)]

twitter <- twitter2021  %>% arrange(Date)
twitter$Date <- as.Date(twitter$Date)
twitter$id <- 1:nrow(twitter)

twitter <- twitter %>%
  set_timeframe() %>%
  select(-c(Username, `Mentioned Users`, Hashtags))
  
twitter$tmp <- clean_text(twitter$Tweet)
clean_twitter <- twitter %>% unnest_tokens(word, tmp)
clean_tweet_words <- clean_twitter %>% anti_join(stop_words)

# export pre-processed data
output_dir <- file.path(getwd(), "data/preprocessed")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

bitcoin %>% write_csv(file.path(output_dir, "BTC_preprocessed.csv"))
dogecoin %>% write_csv(file.path(output_dir, "DOGE_preprocessed.csv"))
tesla %>% write_csv(file.path(output_dir, "TSLA_preprocessed.csv"))
twitter %>% write_csv(file.path(output_dir, "elonmusk_twitter_preprocessed.csv"))
clean_tweet_words %>% write_csv(file.path(output_dir, "elonmusk_twitter_words.csv"))

save(bitcoin, dogecoin, tesla, twitter, clean_tweet_words, file=file.path(output_dir, "all_data.RData"))
