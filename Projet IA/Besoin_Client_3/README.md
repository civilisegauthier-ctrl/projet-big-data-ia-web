
# Script de prédiction d'état d'arbre lors d'une tempête

Ce dossier contient un notebook d'apprentissage et un script Python réutilisable pour prédire `fk_arb_etat` à partir des caractéristiques d'un arbre. Le notebook compare d'abord un `DecisionTreeClassifier` et un `RandomForestClassifier`, puis conserve le meilleur modèle final. Le script propose deux modes : un exemple pré-rempli ou une saisie manuelle dans le terminal.

## Prérequis
- Python 3.8+
- Modules à installer : pandas, numpy, scikit-learn, joblib
- Vérifier que les fichiers suivants sont présents avant de lancer la prédiction :
  - `preprocessors/onehot_encoder.joblib`
  - `preprocessors/categorical_imputer.joblib`
  - `preprocessors/numerical_imputer.joblib`
  - `preprocessors/feature_columns.joblib`
  - `preprocessors/categorical_columns.joblib`
  - `preprocessors/numerical_columns.joblib`
  - `models/random_forest_tempete.joblib`
  - `predict_tempete.py`


## Exemple d'utilisation dans un script Python

```python
from predict_tempete import predict_tree_state

# Exemple de dictionnaire de caractéristiques d'un arbre
exemple = {
    'X': 123456.0,
    'Y': 654321.0,
    'clc_quartier': 'Bellevue',
    'clc_secteur': 'NORD',
    'haut_tot': 12.5,
    'haut_tronc': 2.1,
    'tronc_diam': 35.0,
    'fk_stadedev': 'Adulte',
    'fk_port': 'Semi-érigé',
    'fk_pied': 'Normal',
    'fk_situation': 'Alignement',
    'fk_revetement': 'Gazon',
    'age_estim': 40,
    'villeca': 'NANTES',
    'feuillage': 'Caduc',
    'remarquable': 'NON'
}

# Prédiction
prediction = predict_tree_state(exemple)
print(f"Prédiction de l'état de l'arbre : {prediction}")
```


## Utilisation en ligne de commande
Vous pouvez également exécuter le script directement :

```bash
python predict_tempete.py
```

Le script vous demandera alors :
- Soit d'utiliser un exemple pré-rempli (tapez 1)
- Soit de saisir manuellement les caractéristiques de l'arbre (tapez 2, puis renseignez les valeurs demandées dans le terminal)

Dans les deux cas, la prédiction de l'état de l'arbre sera affichée à la fin.


## Notes importantes
- Les clés du dictionnaire d'entrée doivent correspondre aux colonnes sélectionnées dans le notebook.
- Le script ne relance jamais l'apprentissage : il charge uniquement les fichiers `.joblib` déjà créés.
- Les valeurs manquantes sont gérées par les imputeurs sauvegardés pendant l'entraînement.
- Le notebook compare un arbre de décision simple et une forêt aléatoire pour justifier le choix final.
- Aucune normalisation n'est appliquée, car les modèles comparés sont basés sur des arbres.
