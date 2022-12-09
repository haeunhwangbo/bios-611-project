import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, RandomizedSearchCV, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import RocCurveDisplay, precision_recall_fscore_support
from sklearn.preprocessing import StandardScaler
import logging
import itertools
from pathlib import Path
import pickle

RANDOM_STATE = 0
logging.basicConfig(filename='build_model.log',
                    format='%(asctime)s - %(message)s', level=logging.INFO)

outdir = 'data/model/'
Path(outdir).mkdir(parents=True, exist_ok=True)


def preprocess_input(target: str, metric: str) -> tuple:
    assert target in ['BTC', 'DOGE', 'TSLA'], "Invalid target"
    assert metric in ['Interday_Change', 'Intraday_Volatility']
    features_df = pd.read_csv(
        'data/preprocessed/model_variables.csv', index_col=0).sort_index()
    
    sc = StandardScaler()
    norm_cols = ['n_tweents', 'avg_likes', 'avg_replies']
    tmp = sc.fit_transform(features_df[norm_cols])
    norm_features_df = pd.DataFrame(tmp, 
                                    index=features_df.index, 
                                    columns=norm_cols)
    norm_features_df = pd.concat((norm_features_df, features_df[[
                                'media', 'score', 'BTC_mentioned', 'DOGE_mentioned', 'TSLA_mentioned']]), axis=1)

    if target == 'BTC':
        df = pd.read_csv('data/preprocessed/BTC_preprocessed.csv', index_col=0).reindex(norm_features_df.index)
    elif target == 'DOGE':
        df = pd.read_csv(
            'data/preprocessed/DOGE_preprocessed.csv', index_col=0).reindex(norm_features_df.index)
    elif target == 'TSLA':
        df = pd.read_csv(
            'data/preprocessed/TSLA_preprocessed.csv', index_col=0).reindex(norm_features_df.index)
        df = df.dropna()
        norm_features_df = norm_features_df.reindex(df.index)
    
    if metric == 'Interday_Change':
        labels = (df['Interday_Change'] > 0).astype(int)
    
    elif metric == 'Intraday_Volatility':
        labels = (df['Intraday_Volatility'] >
                  df['Intraday_Volatility'].median()).astype(int)

    assert norm_features_df.shape[0] == len(labels)
    return (norm_features_df.to_numpy(), labels.to_numpy())


def build_rf_model(target: str, metric: str):
    logging.info(f'Started building RF model for {target} {metric}')
    x, y = preprocess_input(target, metric)

    train_x, test_x, train_y, test_y = train_test_split(x, y, test_size=0.25, 
                                                        random_state=RANDOM_STATE)

    ### Random Grid Search
    # Number of trees in random forest
    n_estimators = np.linspace(100, 3000, int((3000-100)/200) + 1, dtype=int)
    # Maximum number of levels in tree
    max_depth = [1, 5, 10, 20, 50, 75, 100]
    # Minimum number of samples required to split a node
    # min_samples_split = [int(x) for x in np.linspace(start = 2, stop = 10, num = 9)]
    min_samples_split = [1, 2, 5, 10, 15, 20, 30]
    # Minimum number of samples required at each leaf node
    min_samples_leaf = [1, 2, 3, 4]
    # Method of selecting samples for training each tree
    bootstrap = [True, False]
    # Criterion
    criterion = ['gini', 'entropy']
    random_grid = {'n_estimators': n_estimators,
                'max_depth': max_depth,
                'min_samples_split': min_samples_split,
                'min_samples_leaf': min_samples_leaf,
                'bootstrap': bootstrap,
                'criterion': criterion}
    rf_base = RandomForestClassifier()
    rf_random = RandomizedSearchCV(estimator=rf_base,
                                   param_distributions=random_grid,
                                   n_iter=100, cv=4,
                                   scoring='f1',
                                   verbose=1,
                                   random_state=RANDOM_STATE, n_jobs=4)
    logging.info(f'Randomized search')
    rf_random.fit(train_x, train_y)
    
    logging.info(f'...finished')

    # Find best model
    best_params = rf_random.best_params_
    rf_best = RandomForestClassifier(n_estimators=best_params['n_estimators'],
                                     max_depth=best_params['max_depth'],
                                     min_samples_split=best_params['min_samples_split'],
                                     min_samples_leaf=best_params['min_samples_leaf'],
                                     criterion=best_params['criterion'],
                                     bootstrap=best_params['bootstrap'])

    rf_cv_score = cross_val_score(rf_best, train_x, train_y, 
                                  scoring='f1', cv=4, n_jobs=3)
    rf_best.fit(train_x, train_y)
    return (rf_best, test_x, test_y)


def model_performance(model, test_x, test_y, target, metric, ax):
    color_dict = {'BTC': 'orange', 'DOGE': 'blue', 'TSLA': 'red'}
    pred = model.predict(test_x)
    precision, recall, f1, _ = precision_recall_fscore_support(test_y, pred, average='binary')

    disp = RocCurveDisplay.from_estimator(
        model, test_x, test_y, ax=ax, alpha=0.8, color=color_dict[target], name='')
    ax.set_title(f'{target} {metric}')
    ax.set_xlabel('FPR')
    ax.set_ylabel('TPR')
    return precision, recall, f1, ax


def main():
    targets = ['BTC', 'DOGE', 'TSLA']
    metrics = ['Intraday_Volatility', 'Interday_Change']
    indices = [a + '-' + b for a, b, in itertools.product(targets, metrics)]
    fig, axes = plt.subplots(len(targets), len(metrics), 
                             figsize=(6, 6), sharex=True, sharey=True, dpi=300)
    results = pd.DataFrame(index=indices, columns=['precision', 'recall', 'f1'])
    results.index.name = 'model'
    for i in range(len(targets)):
        for k in range(len(metrics)):
            target = targets[i]
            metric = metrics[k]
            model, test_x, test_y = build_rf_model(target, metric)
            pickle.dump((model, test_x, test_y), open(
                f'data/model/{target}-{metric}.model.pkl', 'wb'))
            precision, recall, f1, ax = model_performance(model, test_x, test_y, target, metric, axes[i, k])
            results.at[f'{target}-{metric}', 'precision'] = precision
            results.at[f'{target}-{metric}', 'recall'] = recall
            results.at[f'{target}-{metric}', 'f1'] = f1
            
    results.to_csv('data/model/all_model_performance.csv')
    fig.tight_layout()
    fig.savefig('figures/all_models_auc.png', bbox_inches='tight', pad_inches=0.1)


if __name__ == '__main__':
    main()