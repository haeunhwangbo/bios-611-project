library(tidyverse)
library(ggplot2)
library(gridExtra)
library(lubridate)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

twitter <- twitter %>% mutate(year_month = floor_date(Date, "month"))
# Monthly statistics bar chart
# Average number of tweets
# Average number of likes per tweet
# Average number of retweet per tweet
# Frequency of mentions of bitcoin, dogecoin, and tesla

monthly <- twitter %>% group_by(year_month) %>% 
  summarise(n_tweets = n(),
            avg_likes = mean(Likes),
            avg_retweets = mean(Retweets))

p1 <- ggplot(monthly, aes(x=year_month, y=n_tweets)) +
  geom_line() +
  geom_point() +
  ylab("Number of Tweets")


p2 <- ggplot(monthly, aes(x=year_month, y=avg_likes)) +
  geom_line() +
  geom_point() +
  ylab("Average Likes")


p3 <- ggplot(monthly, aes(x=year_month, y=avg_retweets)) +
  geom_line() +
  geom_point() +
  ylab("Average Retweets")


p <- grid.arrange(p1, p2, p3, nrow=3)

# export plots
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

ggsave("monthly_tweet_stats.png",
       plot = p,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)