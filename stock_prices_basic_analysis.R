library(tidyverse)
library(ggplot2)
library(gridExtra)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))


all_stocks <- bind_rows(bitcoin %>% mutate(Name="bitcoin"),
                        dogecoin %>% mutate(Name="dogecoin"),
                        tesla %>% mutate(Name="tesla"))

### Close Prices
# bitcoin
p1 <- ggplot(bitcoin, aes(x=Date, y=Close)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Close Price ($)")

# dogecoin
p2 <- ggplot(dogecoin, aes(x=Date, y=Close)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Close Price ($)")


# tesla
p3 <- ggplot(tesla, aes(x=Date, y=Close)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Close Price ($)")


p <- grid.arrange(p1, p2, p3, nrow=3)

### Volumes

# bicoin
q1 <- ggplot(bitcoin, aes(x=Date, y=Volume)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Volume")

# dogecoin
q2 <- ggplot(dogecoin, aes(x=Date, y=Volume)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Volume")


# tesla
q3 <- ggplot(tesla, aes(x=Date, y=Volume)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Volume")


q <- grid.arrange(q1, q2, q3, nrow=3)

# export figures
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

ggsave("all_stocks_close_price.png",
       plot = p,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("all_stocks_volumes.png",
       plot = q,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)
