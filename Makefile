.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f data/preprocessed/*.csv
	rm -f figures/*.png
	rm -f figures/*.pdf
	rm -f fragments/*.tex
	rm -f report.pdf
	rm -f Rplots*


data/preprocessed/all_data.RData\
 data/preprocessed/BTC_preprocessed.csv\
 data/preprocessed/DOGE_preprocessed.csv\
 data/preprocessed/elonmusk_twitter_preprocessed.csv\
 data/preprocessed/TSLA_preprocessed.csv:\
 preprocess.R
	Rscript preprocess.R


figures/all_stocks_open_price.png: data/preprocessed/all_data.RData \
                                   time_vs_prices.R
	Rscript time_vs_prices.R


figures/all_stocks_daily_high_low.png\
 figures/all_stocks_daily_close_change.png: data/preprocessed/all_data.RData \
                                            time_vs_volatility.R
	Rscript time_vs_volatility.R


figures/monthly_tweet_stats.png: data/preprocessed/all_data.RData \
                                 twitter_statistics.R
	Rscript twitter_statistics.R


report.pdf: figures/all_stocks_open_price.png \
            figures/all_stocks_daily_high_low.png \
			figures/all_stocks_daily_close_change.png \
			figures/monthly_tweet_stats.png
	Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"