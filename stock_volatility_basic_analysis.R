library(tidyverse)
library(ggplot2)
library(gridExtra)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))


# bicoin
p1 <- ggplot(bitcoin, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Intraday Volatility")

# dogecoin
p2 <- ggplot(dogecoin, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Intraday Volatility")


# tesla
p3 <- ggplot(tesla, aes(x=Date, y=Intraday_Volatility)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Intraday Volatility")


p <- grid.arrange(p1, p2, p3, nrow=3)


# bicoin
q1 <- ggplot(bitcoin, aes(x=Date, y=Interday_Change)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Inter Day Change (%)")

# dogecoin
q2 <- ggplot(dogecoin, aes(x=Date, y=Interday_Change)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Inter Day Change (%)")


# tesla
q3 <- ggplot(tesla, aes(x=Date, y=Interday_Change)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Inter Day Change (%)")


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