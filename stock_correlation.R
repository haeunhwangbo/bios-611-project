library(tidyverse)
library(ggplot2)
library(gridExtra)
library(ggcorrplot)

load(file.path(getwd(), 'data/preprocessed/all_data.RData'))

# prepare dataframe
merged <- bind_cols(bitcoin %>% select(c(Date, Close, Interday_Change, Intraday_Volatility)) %>% filter(Date %in% tesla$Date), 
                    dogecoin %>% select(c(Date, Close, Interday_Change, Intraday_Volatility)) %>% filter(Date %in% tesla$Date),
                    tesla %>% select(c(Date, Close, Interday_Change, Intraday_Volatility)))

merged <- merged %>% select(-c(Date...5, Date...9))
colnames(merged) <- c("Date", paste0(rep(c("Close_", "Interday_Change_", "Intraday_Volatility_"), 3), c(rep("BTC", 3), rep("DGE", 3), rep("TSLA", 3))))

# build correlation matrix
corr_close <- cor(merged %>% select(c(Close_BTC, Close_DGE, Close_TSLA))) %>% round(2)
corr_intraday_volatility <- cor(merged %>% select(c(Intraday_Volatility_BTC, Intraday_Volatility_DGE, Intraday_Volatility_TSLA))) %>% round(2)
corr_interday_change <- cor(merged %>% select(c(Interday_Change_BTC, Interday_Change_DGE,Interday_Change_TSLA)) %>% drop_na()) %>% round(2)


items <- c("BTC", "DGE", "TSLA")
rownames(corr_close) <- items
colnames(corr_close) <- items
rownames(corr_intraday_volatility) <- items
colnames(corr_intraday_volatility) <- items
rownames(corr_interday_change) <- items
colnames(corr_interday_change) <- items

# plot
p1 <- ggcorrplot(corr_close, lab= T, type = 'lower') + ggtitle("Close Price Correlation")
p2 <- ggcorrplot(corr_interday_change, lab= T, type = 'lower') + ggtitle("Interday Change Correlation")
p3 <- ggcorrplot(corr_intraday_volatility, lab= T, type = 'lower') + ggtitle("Intraday Volatility Correlation")
# export plots
output_dir <- file.path(getwd(), "figures")

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

ggsave("close_price_correlation.png",
       plot = p1,
       width = 4,
       height = 4,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("interday_change_correlation.png",
       plot = p2,
       width = 4,
       height = 4,
       units = 'in',
       device = 'png',
       path = output_dir)

ggsave("intraday_volatility_correlation.png",
       plot = p2,
       width = 4,
       height = 4,
       units = 'in',
       device = 'png',
       path = output_dir)