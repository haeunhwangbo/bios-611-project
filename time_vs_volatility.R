library(tidyverse)
library(ggplot2)
library(gridExtra)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

bitcoin <- bitcoin %>% mutate(High_Low = High - Low,
                              Daily_Change = 100* (Close - lag(Close)) / lag(Close))
dogecoin <- dogecoin %>% mutate(High_Low = High - Low,
                                Daily_Change = 100* (Close - lag(Close)) / lag(Close))
tesla <- tesla %>% mutate(High_Low = High - Low,
                          Daily_Change = 100 * (Close - lag(Close)) / lag(Close))


# bicoin
p1 <- ggplot(bitcoin, aes(x=Date, y=High_Low)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Daily High - Low ($)")

# dogecoin
p2 <- ggplot(dogecoin, aes(x=Date, y=High_Low)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Daily High - Low ($)")


# tesla
p3 <- ggplot(tesla, aes(x=Date, y=High_Low)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Daily High - Low ($)")


p <- grid.arrange(p1, p2, p3, nrow=3)


# bicoin
q1 <- ggplot(bitcoin, aes(x=Date, y=Daily_Change)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Daily Change (%)")

# dogecoin
q2 <- ggplot(dogecoin, aes(x=Date, y=Daily_Change)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Daily Change (%)")


# tesla
q3 <- ggplot(tesla, aes(x=Date, y=Daily_Change)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Daily Change (%)")


q <- grid.arrange(q1, q2, q3, nrow=3)


# export plots
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

ggsave("all_stocks_daily_high_low.png",
       plot = p,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("all_stocks_daily_close_change.png",
       plot = q,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)