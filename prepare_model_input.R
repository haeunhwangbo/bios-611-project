library(tidyverse)
library(tidytext)
library(GGally)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

find_mentioned_date <- function(query){
  clean_tweet_words[clean_tweet_words$word %>% str_which(query), 'Date'] %>% unique() %>% arrange()
}

add_mentioned_date <- function(df, mentioned_date){
  df <- df %>% mutate(Mentioned = if_else(Date %in% mentioned_date$Date, 1, 0))
  df$Mentioned <- as.factor(df$Mentioned)
  return(df)
}

sentiments <- get_sentiments("afinn")
sentiment_daily <- clean_tweet_words %>% inner_join(sentiments) %>% group_by(Date) %>% summarize(score=sum(value))

twitter$no_media <- twitter$Media %>% is.na() %>% as.integer()
model_dat <- twitter %>% group_by(Date) %>% 
  summarize(n_tweents = n(), avg_retweets = mean(Retweets), avg_likes = mean(Likes), avg_replies = mean(Replies), media=1-prod(no_media))

model_dat <- model_dat %>% left_join(sentiment_daily) %>% mutate(score = replace_na(score, 0))

bitcoin_mentions <- union(find_mentioned_date("bitcoin"), find_mentioned_date("btc"))
dogecoin_mentions <- find_mentioned_date("doge")
tesla_mentions <- union(find_mentioned_date("tesla"), find_mentioned_date("tsla"))

model_dat <- model_dat %>% mutate(BTC_mentioned = if_else(Date %in% bitcoin_mentions$Date, 1, 0),
                                  DOGE_mentioned = if_else(Date %in% dogecoin_mentions$Date, 1, 0),
                                  TSLA_mentioned = if_else(Date %in% tesla_mentions$Date, 1, 0))

#### model variables
# number of tweets per day
# mentioned the word?
# sentiment
# how many retweets? average retweets
# how many replies? average replies
# how many likes? average likes
# was there media (binary)

# save model data

model_dat %>% write_csv(file.path("data/preprocessed", "model_variables.csv"))

# save pair plot

output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}
p <- ggpairs(model_dat, columns = 2:ncol(model_dat), diag = list(continuous = wrap("barDiag")))
ggsave("model_variables_pairplot.png",
       plot = p,
       width = 8,
       height = 8,
       units = 'in',
       device = 'png',
       path = output_dir)

