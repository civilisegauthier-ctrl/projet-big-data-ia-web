from pathlib import Path

import joblib
import numpy as np
import pandas as pd


BASE_DIR = Path(__file__).resolve().parent
PREPROCESSOR_DIR = BASE_DIR / "preprocessors"
MODEL_DIR = BASE_DIR / "models"


def load_artifacts():
    """Charge le modèle et les objets de prétraitement sauvegardés."""
    artifacts = {
        "model": joblib.load(MODEL_DIR / "random_forest_tempete.joblib"),
        "encoder": joblib.load(PREPROCESSOR_DIR / "onehot_encoder.joblib"),
        "categorical_imputer": joblib.load(PREPROCESSOR_DIR / "categorical_imputer.joblib"),
        "numerical_imputer": joblib.load(PREPROCESSOR_DIR / "numerical_imputer.joblib"),
        "feature_columns": joblib.load(PREPROCESSOR_DIR / "feature_columns.joblib"),
        "categorical_columns": joblib.load(PREPROCESSOR_DIR / "categorical_columns.joblib"),
        "numerical_columns": joblib.load(PREPROCESSOR_DIR / "numerical_columns.joblib"),
    }
    return artifacts


def preprocess_input(input_dict, artifacts):
    """
    Reproduit le prétraitement appris dans le notebook.
    Le script ne réentraîne rien : il applique seulement les objets déjà sauvegardés.
    """
    feature_columns = artifacts["feature_columns"]
    categorical_columns = artifacts["categorical_columns"]
    numerical_columns = artifacts["numerical_columns"]

    X_input = pd.DataFrame([input_dict])

    # On remet toutes les colonnes attendues dans le bon ordre.
    for column in feature_columns:
        if column not in X_input.columns:
            X_input[column] = np.nan
    X_input = X_input[feature_columns]

    X_cat = artifacts["categorical_imputer"].transform(X_input[categorical_columns])
    X_num = artifacts["numerical_imputer"].transform(X_input[numerical_columns])
    X_cat_encoded = artifacts["encoder"].transform(X_cat)

    return np.hstack([X_num, X_cat_encoded])


def predict_tree_state(input_dict):
    """
    Prédit la classe fk_arb_etat à partir des caractéristiques d'un arbre.
    """
    artifacts = load_artifacts()
    X_ready = preprocess_input(input_dict, artifacts)
    prediction = artifacts["model"].predict(X_ready)
    return prediction[0]


if __name__ == "__main__":
    print("Choisissez le mode d'utilisation :")
    print("1. Utiliser un exemple pré-rempli")
    print("2. Saisir manuellement les caractéristiques de l'arbre")
    mode = input("Votre choix (1/2) : ").strip()

    colonnes = [
        "X",
        "Y",
        "clc_quartier",
        "clc_secteur",
        "haut_tot",
        "haut_tronc",
        "tronc_diam",
        "fk_stadedev",
        "fk_port",
        "fk_pied",
        "fk_situation",
        "fk_revetement",
        "age_estim",
        "villeca",
        "feuillage",
        "remarquable",
    ]

    if mode == "1":
        exemple = {
            "X": 123456.0,
            "Y": 654321.0,
            "clc_quartier": "Bellevue",
            "clc_secteur": "NORD",
            "haut_tot": 12.5,
            "haut_tronc": 2.1,
            "tronc_diam": 35.0,
            "fk_stadedev": "Adulte",
            "fk_port": "Semi-érigé",
            "fk_pied": "Normal",
            "fk_situation": "Alignement",
            "fk_revetement": "Gazon",
            "age_estim": 40,
            "villeca": "NANTES",
            "feuillage": "Caduc",
            "remarquable": "NON",
        }
        prediction = predict_tree_state(exemple)
        print(f"Prédiction de l'état de l'arbre : {prediction}")
    elif mode == "2":
        print("Veuillez renseigner les caractéristiques de l'arbre :")
        user_input = {}
        for col in colonnes:
            value = input(f"{col} : ").strip()
            if col in ["X", "Y", "haut_tot", "haut_tronc", "tronc_diam", "age_estim"]:
                try:
                    value = float(value)
                except ValueError:
                    print(f"Valeur non valide pour {col}, la valeur manquante sera imputée.")
                    value = np.nan
            user_input[col] = value if value != "" else np.nan

        prediction = predict_tree_state(user_input)
        print(f"Prédiction de l'état de l'arbre : {prediction}")
    else:
        print("Choix non reconnu. Arrêt du script.")
