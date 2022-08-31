# BIOS 611 Project

Author: Haeun (Hannah) Hwangbo
Fall 2022


## Overview

### Elon Musk’s tweets’ influence on Tesla, Bitcoin, and Dogecoin prices
Elon Musk, CEO of Tesla and SpaceX, is curently one of the most influential businessmen 
on the planet. He is well known to be active on social media, especially Twitter. His 
tweets have been caught up in various controversies, sometimes creating chaos for the 
stockholders of his companies. His tweets have also caused the prices of cryptocurrencies 
to swing wildly in the past two years. For instance, after his first tweet about Dogecoin, 
a lesser-known cryptocurrency at that time, the prices of this crypto skyrocketed. 
A Bloomberg opinion columnist, Matt Levine, made a remark on this phenomenon, calling it 
“the Elon Markets Hypothesis”. Levine commented “the way finance works now is that things 
are valuable not based on their cash flows but on their proximity to Elon Musk.” This motivated 
the project.

In this project, I will analyze how Elon Musk’s tweets impacted the prices of Tesla’s stock 
market prices as well as the prices of two cryptocurrencies that have been at the heart of 
the controversies, Bitcoin and Dogecoin. The timeframe will be between January 1st of 2020 
to March 5th of 2022. I will use daily prices (volume, open, close, high, low) for Tesla, 
Bitcoin, and Dogecoin. The volatility will be measured as the difference between the daily 
high and low prices. 30-minute window prices are available for Bitcoin, and this will be used 
for more detailed analysis. For Elon Musk’s tweets, the posting time, the number of retweets, 
the number of likes, and the text contents will be used.

Part 1 will be exploratory analysis. In this part, I will answer the following questions. 
What are the historical price trends during this time? What were the trends of volatility? 
How does volume correlate with volatility? Were there similar trends between the two cryptocurrencies? 
What was the frequency of Elon Musk’s tweets during this time? What were the most often used keywords? 

Part 2 will investigate the relationship between Musk’s tweets and stock/crypto prices. 
I will try to answer the following questions. What were the keywords in his tweets that triggered 
the largest volatility in the prices? How much would you have earned if you had bought the 
stock/crypto right before Musk’s mention of it? How long does the volatility last after Elon
Musk’s tweet mentioning Bitcoin? 


## Datasets

- [Elon Musk Tweets](https://www.kaggle.com/datasets/ayhmrba/elon-musk-tweets-2010-2021?resource=download)

- - [Tesla daily stock market price](https://www.nasdaq.com/market-activity/stocks/tsla/historical)

[Bitcoin daily price](https://www.kaggle.com/datasets/rishabhkmr/bitcoin-historical-price-usd)

- [Dogecoin daily price](https://www.kaggle.com/datasets/dhruvildave/dogecoin-historical-data)

