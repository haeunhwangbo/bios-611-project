library(tidyverse)
library(ggplot2)
library(ggpubr)
library(gridExtra)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

find_mentioned_date <- function(query){
  clean_tweet_words[clean_tweet_words$word %>% str_which(query), 'Date'] %>% unique() %>% arrange()
}


add_mentioned_date <- function(df, mentioned_date){
  df <- df %>% mutate(Mentioned = if_else(Date %in% mentioned_date$Date, "Yes", "No"))
  df$Mentioned <- as.factor(df$Mentioned)
  return(df)
}


bitcoin_mentions <- union(find_mentioned_date("bitcoin"), find_mentioned_date("btc"))
dogecoin_mentions <- find_mentioned_date("doge")
tesla_mentions <- union(find_mentioned_date("tesla"), find_mentioned_date("tsla"))

bitcoin <- add_mentioned_date(bitcoin, bitcoin_mentions)
dogecoin <-add_mentioned_date(dogecoin, dogecoin_mentions)
tesla <- add_mentioned_date(tesla, tesla_mentions)

### Boxplots

box_bitcoin_inter <- ggboxplot(bitcoin, x="Mentioned", y="Interday_Change", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Bitcoin")

box_bitcoin_intra <- ggboxplot(bitcoin, x="Mentioned", y="Intraday_Volatility", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Bitcoin")

box_doge_inter <- ggboxplot(dogecoin, x="Mentioned", y="Interday_Change", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Dogecoin")

box_doge_intra <- ggboxplot(dogecoin, x="Mentioned", y="Intraday_Volatility", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Dogecoin")

box_tesla_inter <- ggboxplot(tesla, x="Mentioned", y="Interday_Change", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Tesla")

box_tesla_intra <- ggboxplot(tesla, x="Mentioned", y="Intraday_Volatility", font.label=list(size=9, color="black")) +
  stat_compare_means(method = 't.test') +
  ggtitle("Tesla")

box_inter <- grid.arrange(box_bitcoin_inter, box_doge_inter, box_tesla_inter, ncol=3)
box_intra <- grid.arrange(box_bitcoin_intra, box_doge_intra, box_tesla_intra, ncol=3)

### Close Prices
# bitcoin
p1 <- ggplot(bitcoin, aes(x=Date, y=Close)) +
  geom_line(color='orange') +
  geom_vline(data=bitcoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Bitcoin") +
  ylab("Close Price ($)")
p1

# dogecoin
p2 <- ggplot(dogecoin, aes(x=Date, y=Close)) +
  geom_line(color='blue') +
  geom_vline(data=dogecoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Dogecoin") +
  ylab("Close Price ($)")
p2

# tesla
p3 <- ggplot(tesla, aes(x=Date, y=Close)) +
  geom_line(color='red') +
  geom_vline(data=tesla_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Tesla") +
  ylab("Close Price ($)")
p3

p <- grid.arrange(p1, p2, p3, nrow=3)

q1 <- ggplot(bitcoin, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='orange') +
  geom_vline(data=bitcoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Bitcoin") +
  ylab("Intraday Volatility")


# dogecoin
q2 <- ggplot(dogecoin, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='blue') +
  geom_vline(data=dogecoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Dogecoin") +
  ylab("Intraday Volatility")


# tesla
q3 <- ggplot(tesla, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='red') +
  geom_vline(data=tesla_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Tesla") +
  ylab("Intraday Volatility")


q <- grid.arrange(q1, q2, q3, nrow=3)


r1 <- ggplot(bitcoin, aes(x=Date, y=Interday_Change)) +
  geom_line(color='orange') +
  geom_vline(data=bitcoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Bitcoin") +
  ylab("Interday Change (%)")


# dogecoin
r2 <- ggplot(dogecoin, aes(x=Date, y=Interday_Change)) +
  geom_line(color='blue') +
  geom_vline(data=dogecoin_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Dogecoin") +
  ylab("Interday Change (%)")


# tesla
r3 <- ggplot(tesla, aes(x=Date, y=Interday_Change)) +
  geom_line(color='red') +
  geom_vline(data=tesla_mentions, aes(xintercept=Date), linetype=2) +
  ggtitle("Tesla") +
  ylab("Interday Change (%)")


r <- grid.arrange(r1, r2, r3, nrow=3)


# export figures
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}


ggsave("tweet_mentions_close_price_lineplot.png",
       plot = p,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("tweet_mentions_intraday_volatility_lineplot.png",
       plot = q,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("tweet_mentions_interday_change_lineplot.png",
  plot = r,
  width = 4,
  height = 6,
  units = "in",
  device = "png",
  path = output_dir
)

ggsave("tweet_mentions_interday_change_boxplot.png",
       plot = box_inter,
       width = 8,
       height = 4,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("tweet_mentions_intraday_volatility_boxplot.png",
       plot = box_intra,
       width = 8,
       height = 4,
       units = 'in',
       device = 'png',
       path = output_dir)

