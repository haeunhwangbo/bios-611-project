library(tidyverse)
library(ggplot2)
library(gridExtra)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))


all_stocks <- bind_rows(bitcoin %>% mutate(Name="bitcoin"),
                        dogecoin %>% mutate(Name="dogecoin"),
                        tesla %>% mutate(Name="tesla"))

# bicoin
p1 <- ggplot(bitcoin, aes(x=Date, y=Open)) +
  geom_line(color='orange') +
  ggtitle("Bitcoin") +
  ylab("Open Price ($)")

# dogecoin
p2 <- ggplot(dogecoin, aes(x=Date, y=Open)) +
  geom_line(color='blue') +
  ggtitle("Dogecoin") +
  ylab("Open Price ($)")


# tesla
p3 <- ggplot(tesla, aes(x=Date, y=Open)) +
  geom_line(color='red') +
  ggtitle("Tesla") +
  ylab("Open Price ($)")


p <- grid.arrange(p1, p2, p3, nrow=3)

# export pre-processed data
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

ggsave("all_stocks_open_price.png",
       plot = p,
       width = 4,
       height = 6,
       units = 'in',
       device = 'png',
       path = output_dir)
