import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import itertools
import pickle

# Plot precision, recall, f1 bar plots
df = pd.read_csv('data/model/all_model_performance.csv', index_col=0)
fig, ax = plt.subplots(figsize=(6, 4), dpi=300)
df.plot.bar(ax=ax)
ax.set_xticklabels(ax.get_xticklabels(), rotation=45, ha='right')
fig.savefig('figures/all_models_performance_barplot.png', bbox_inches='tight', pad_inches=0.1)

# plot feature importance
targets = ['BTC', 'DOGE', 'TSLA']
metrics = ['Intraday_Volatility', 'Interday_Change']
features = ['n_tweents', 'avg_likes', 'avg_replies', 'media',
            'score', 'BTC_mentioned', 'DOGE_mentioned', 'TSLA_mentioned']
models = [a + '-' + b for a, b, in itertools.product(targets, metrics)]
dat = np.zeros(len(features))
for model in [a + '-' + b for a, b, in itertools.product(targets, metrics)]:
    with open(f'data/model/{model}.model.pkl', 'rb') as f:
        model, test_x, test_y = pickle.load(f)
    dat = np.vstack((dat, model.feature_importances_))
df = pd.DataFrame(dat[1:, ], index=models, columns=features)
fig, ax = plt.subplots(figsize=(6, 4), dpi=300)
df.plot.bar(ax=ax)
ax.set_xticklabels(ax.get_xticklabels(), rotation=45, ha='right')
ax.set_title('Feature Importance')
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
fig.savefig('figures/all_models_feature_importance_barplot.png',
            bbox_inches='tight', pad_inches=0.1)
