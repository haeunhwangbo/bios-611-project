library(tidyverse)
library(tidytext)
library(ggplot2)
library(wordcloud)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

# plot and save figure
p1 <- clean_tweet_words %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Count of unique words found in tweets",
       subtitle = "Stop words removed from the list")

ggsave("tweet_word_counts.png",
       plot = p1,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)

# word cloud
word_counts <- clean_tweet_words %>% count(word, sort=TRUE)
png(file=file.path(output_dir, "tweet_word_cloud.png"))
wordcloud(words = word_counts$word, freq = word_counts$n, 
          min.freq = 1, max.words=200, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
dev.off()


