.PHONY: clean
SHELL: /bin/bash

clean:
	rm -rf data/preprocessed/
	rm -rf data/model/
	rm -rf figures/
	rm -f fragments/*.tex
	rm -f report.pdf
	rm -f Rplots*

# preprocessing
data/preprocessed/all_data.RData\
 data/preprocessed/BTC_preprocessed.csv\
 data/preprocessed/DOGE_preprocessed.csv\
 data/preprocessed/elonmusk_twitter_preprocessed.csv\
 data/preprocessed/TSLA_preprocessed.csv: preprocess.R
	Rscript preprocess.R

# stock prices basic analysis
figures/all_stocks_close_price.png\
 figures/all_stocks_volumes.png: data/preprocessed/all_data.RData \
                                 stock_prices_basic_analysis.R
	Rscript stock_prices_basic_analysis.R

# stock volatility basic analysis
figures/all_stocks_daily_high_low.png\
 figures/all_stocks_daily_close_change.png: data/preprocessed/all_data.RData \
                                            stock_volatility_basic_analysis.R
	Rscript stock_volatility_basic_analysis.R

# correlation between stocks
figures/close_price_correlation.png\
 figures/interday_change_correlation.png\
 intraday_volatility_correlation.png: data/preprocessed/all_data.RData \
                                      stock_correlation.R
	Rscript stock_correlation.R

# basic tweet analysis
figures/monthly_tweet_stats.png: data/preprocessed/all_data.RData \
                                 twitter_statistics.R
	Rscript twitter_statistics.R

# tweet mentions and price
figures/tweet_mentions_close_price_lineplot.png\
 figures/tweet_mentions_interday_change_lineplot.png\
 figures/tweet_mentions_intraday_volatility_lineplot.png\
 figures/tweet_mentions_interday_change_boxplot.png\
 figures/tweet_mentions_intraday_volatility_boxplot.png: data/preprocessed/all_data.RData
	Rscript tweet_word_mentions_and_price.R

# basic text analysis
figures/tweet_word_counts.png\
 figures/tweet_word_cloud.png: data/preprocessed/all_data.RData \
                               basic_text_analysis.R
	Rscript basic_text_analysis.R

# generate model input data for random forest
figures/model_variables_pairplot.png\
 data/preprocessed/model_variables.csv: data/preprocessed/all_data.RData \
                                        prepare_model_input.R
	Rscript prepare_model_input.R

# build model
figures/all_models_auc.png\
 data/model/BTC-Interday_Change.model.pkl\
 data/model/BTC-Intraday_Volatility.model.pkl\
 data/model/DOGE-Interday_Change.model.pkl\
 data/model/DOGE-Intraday_Volatility.model.pkl\
 data/model/TSLA-Interday_Change.model.pkl\
 data/model/TSLA-Intraday_Volatility.model.pkl\
 data/model/all_model_performance.csv: data/preprocessed/model_variables.csv \
                            data/preprocessed/BTC_preprocessed.csv \
							data/preprocessed/DOGE_preprocessed.csv \
							data/preprocessed/TSLA_preprocessed.csv
	python3 build_model.py

# model performance comparison
figures/all_models_feature_importance_barplot.png\
 figures/all_models_performance_barplot.png: data/model/all_model_performance.csv \
                                             data/model/BTC-Interday_Change.model.pkl\
											 data/model/BTC-Intraday_Volatility.model.pkl\
											 data/model/DOGE-Interday_Change.model.pkl\
											 data/model/DOGE-Intraday_Volatility.model.pkl\
											 data/model/TSLA-Interday_Change.model.pkl\
											 data/model/TSLA-Intraday_Volatility.model.pkl                                     
	python3 compare_models.py

# write-up report
report.pdf: figures/monthly_tweet_stats.png \
            figures/tweet_word_counts.png \
			figures/tweet_word_cloud.png \
			figures/all_stocks_close_price.png \
			figures/all_stocks_daily_high_low.png \
			figures/all_stocks_daily_close_change.png \
			figures/tweet_mentions_interday_change_lineplot.png \
			figures/tweet_mentions_intraday_volatility_lineplot.png \
			figures/tweet_mentions_interday_change_boxplot.png \
			figures/tweet_mentions_intraday_volatility_boxplot.png \
			figures/model_variables_pairplot.png \
			figures/all_models_feature_importance_barplot.png \
			figures/all_models_performance_barplot.png \
			figures/all_models_auc.png \
			report.Rmd
	Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"
