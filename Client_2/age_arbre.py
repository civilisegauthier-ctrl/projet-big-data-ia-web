"""
age_arbre.py
------------
Script unique de prédiction de l'âge des arbres urbains.
Modèle : Random Forest optimisé (GridSearchCV), multi-features.

── ENTRAÎNEMENT (à faire une seule fois) ──────────────────────────────────────
    python age_arbre.py train --data Données_V4.csv

    Génère : model_rf_optimise.pkl dans le même dossier.

── PRÉDICTION (charge le modèle, sans ré-entraîner) ──────────────────────────
    Mode interactif (saisie guidée) :
        python age_arbre.py predict

    Mode ligne de commande :
        python age_arbre.py predict \\
            --tronc_diam 45 \\
            --haut_tot 12 \\
            --haut_tronc 2.5 \\
            --clc_nbr_diag 3 \\
            --fk_stadedev Adulte \\
            --fk_situation Alignement \\
            --fk_port Libre \\
            --fk_pied Asphalte \\
            --remarquable Non \\
            --feuillage Persistant
"""

import argparse
import os
import pickle
import sys

import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestRegressor
from sklearn.impute import SimpleImputer
from sklearn.metrics import (
    mean_absolute_error,
    mean_absolute_percentage_error,
    r2_score,
    root_mean_squared_error,
)
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

# ── Constantes ─────────────────────────────────────────────────────────────
FEATURES_NUM = ['tronc_diam', 'haut_tot', 'haut_tronc', 'clc_nbr_diag']
FEATURES_CAT = ['fk_stadedev', 'fk_situation', 'fk_port', 'fk_pied', 'remarquable', 'feuillage']
TARGET       = 'age_estim'
MODEL_PATH   = os.path.join(os.path.dirname(os.path.abspath(__file__)), "model_rf_optimise.pkl")


# ══════════════════════════════════════════════════════════════════════════════
#  SOUS-COMMANDE : train
# ══════════════════════════════════════════════════════════════════════════════

def cmd_train(args: argparse.Namespace) -> None:
    """Entraîne le Random Forest optimisé et sauvegarde le pipeline."""

    # 1. Chargement & nettoyage
    print(f"\n[1/4] Chargement des données : {args.data}")
    df = pd.read_csv(args.data, sep=';')

    df_clean = df[df['fk_arb_etat'] == 'EN PLACE'].copy()
    df_clean = df_clean[
        (df_clean['tronc_diam'] > 0) &
        (df_clean[TARGET] > 0)
    ]
    df_clean = df_clean[FEATURES_NUM + FEATURES_CAT + [TARGET]].dropna(subset=[TARGET])
    print(f"   → {len(df_clean)} arbres valides")

    # 2. Split Train / Test
    print("\n[2/4] Séparation Train / Test (80 / 20)")
    X = df_clean[FEATURES_NUM + FEATURES_CAT]
    y = df_clean[TARGET]
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )
    print(f"   → Train : {len(X_train)} | Test : {len(X_test)}")

    # 3. Pipeline : préprocesseur + Random Forest
    preprocessor = ColumnTransformer(transformers=[
        ('num',
         Pipeline([
             ('imputer', SimpleImputer(strategy='median')),
             ('scaler',  StandardScaler()),
         ]),
         FEATURES_NUM),
        ('cat',
         Pipeline([
             ('imputer', SimpleImputer(strategy='most_frequent')),
             ('encoder', OneHotEncoder(handle_unknown='ignore', sparse_output=False)),
         ]),
         FEATURES_CAT),
    ])

    pipeline = Pipeline([
        ('preprocessing', preprocessor),
        ('modele', RandomForestRegressor(random_state=42, n_jobs=-1)),
    ])

    param_grid = {
        'modele__n_estimators'     : [100, 200, 300],
        'modele__max_depth'        : [None, 10, 20],
        'modele__min_samples_split': [2, 5, 10],
        'modele__min_samples_leaf' : [1, 2, 4],
        'modele__max_features'     : ['sqrt', 'log2'],
    }
    nb = 1
    for v in param_grid.values():
        nb *= len(v)
    print(f"\n[3/4] GridSearchCV — {nb} combinaisons × 5 folds (peut prendre quelques minutes)")

    grid_search = GridSearchCV(
        estimator=pipeline,
        param_grid=param_grid,
        cv=5,
        scoring='neg_root_mean_squared_error',
        n_jobs=-1,
        refit=True,
        verbose=1,
    )
    grid_search.fit(X_train, y_train)

    best = grid_search.best_estimator_

    print("\n   Meilleurs hyperparamètres :")
    for param, val in grid_search.best_params_.items():
        print(f"     {param:<35} : {val}")

    # Évaluation sur le jeu de test
    y_pred = best.predict(X_test)
    print("\n   ── Métriques sur le jeu de test ──────────────")
    print(f"   MAE  : {mean_absolute_error(y_test, y_pred):.2f} ans")
    print(f"   RMSE : {root_mean_squared_error(y_test, y_pred):.2f} ans")
    print(f"   R²   : {r2_score(y_test, y_pred):.4f}")
    print(f"   MAPE : {mean_absolute_percentage_error(y_test, y_pred)*100:.2f} %")

    # 4. Sauvegarde
    print(f"\n[4/4] Sauvegarde → {MODEL_PATH}")
    with open(MODEL_PATH, 'wb') as f:
        pickle.dump(best, f)
    print("   ✔ Modèle sauvegardé.")
    print("\n✅ Entraînement terminé. Utilisez maintenant :\n"
          "   python age_arbre.py predict --tronc_diam ... \n")


# ══════════════════════════════════════════════════════════════════════════════
#  SOUS-COMMANDE : predict
# ══════════════════════════════════════════════════════════════════════════════

def load_model():
    """Charge le modèle pré-entraîné. Quitte avec un message clair si absent."""
    if not os.path.exists(MODEL_PATH):
        print(f"\n❌ Modèle introuvable : {MODEL_PATH}")
        print("   → Lancez d'abord : python age_arbre.py train --data Données_V4.csv")
        sys.exit(1)
    with open(MODEL_PATH, 'rb') as f:
        model = pickle.load(f)
    print(f"   ✔ Modèle chargé ({MODEL_PATH})")
    return model


def build_dataframe(args: argparse.Namespace) -> pd.DataFrame:
    """Construit le DataFrame d'entrée (une ligne) à partir des arguments."""
    return pd.DataFrame({
        'tronc_diam'   : [float(args.tronc_diam)],
        'haut_tot'     : [float(args.haut_tot)],
        'haut_tronc'   : [float(args.haut_tronc)],
        'clc_nbr_diag' : [int(args.clc_nbr_diag)],
        'fk_stadedev'  : [args.fk_stadedev],
        'fk_situation' : [args.fk_situation],
        'fk_port'      : [args.fk_port],
        'fk_pied'      : [args.fk_pied],
        'remarquable'  : [args.remarquable],
        'feuillage'    : [args.feuillage],
    }, columns=FEATURES_NUM + FEATURES_CAT)


def interactive_input() -> argparse.Namespace:
    """Saisie guidée dans le terminal quand aucun argument n'est fourni."""
    print("\n" + "="*55)
    print("  🌳  PRÉDICTION DE L'ÂGE D'UN ARBRE  🌳")
    print("="*55)
    print("Entrez les caractéristiques de l'arbre :\n")

    ns = argparse.Namespace()
    ns.tronc_diam   = input("  Diamètre du tronc   (cm) : ").strip()
    ns.haut_tot     = input("  Hauteur totale       (m) : ").strip()
    ns.haut_tronc   = input("  Hauteur du tronc     (m) : ").strip()
    ns.clc_nbr_diag = input("  Nombre de diagnostics    : ").strip()
    print()
    ns.fk_stadedev  = input("  Stade de développement   : ").strip()
    ns.fk_situation = input("  Situation                : ").strip()
    ns.fk_port      = input("  Port                     : ").strip()
    ns.fk_pied      = input("  Pied                     : ").strip()
    ns.remarquable  = input("  Remarquable (Oui/Non)    : ").strip()
    ns.feuillage    = input("  Type de feuillage        : ").strip()
    return ns


def cmd_predict(args: argparse.Namespace) -> None:
    """Charge le modèle et prédit l'âge de l'arbre décrit par args."""

    # Mode interactif si aucune valeur numérique fournie
    if args.tronc_diam is None:
        args = interactive_input()

    print("\n[Chargement du modèle...]")
    model = load_model()

    X_input = build_dataframe(args)
    age_predit = float(model.predict(X_input)[0])

    print("\n" + "="*55)
    print("  RÉSULTAT DE LA PRÉDICTION")
    print("="*55)
    print(f"  Diamètre du tronc   : {args.tronc_diam} cm")
    print(f"  Hauteur totale      : {args.haut_tot} m")
    print(f"  Hauteur du tronc    : {args.haut_tronc} m")
    print(f"  Nb diagnostics      : {args.clc_nbr_diag}")
    print(f"  Stade développement : {args.fk_stadedev}")
    print(f"  Situation           : {args.fk_situation}")
    print(f"  Port                : {args.fk_port}")
    print(f"  Pied                : {args.fk_pied}")
    print(f"  Remarquable         : {args.remarquable}")
    print(f"  Feuillage           : {args.feuillage}")
    print("-"*55)
    print(f"  🌲 Âge estimé (Random Forest) : {age_predit:.1f} ans")
    print("="*55 + "\n")


# ══════════════════════════════════════════════════════════════════════════════
#  PARSEUR PRINCIPAL
# ══════════════════════════════════════════════════════════════════════════════

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog='age_arbre.py',
        description="Prédiction de l'âge d'un arbre — Random Forest optimisé.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Exemples :\n"
            "  python age_arbre.py train --data Données_V4.csv\n"
            "  python age_arbre.py predict                          # mode interactif\n"
            "  python age_arbre.py predict --tronc_diam 45 --haut_tot 12 "
            "--haut_tronc 2.5 --clc_nbr_diag 3 \\\n"
            "      --fk_stadedev Adulte --fk_situation Alignement "
            "--fk_port Libre --fk_pied Asphalte \\\n"
            "      --remarquable Non --feuillage Persistant\n"
        ),
    )
    subparsers = parser.add_subparsers(dest='commande', required=True)

    # ── train ──────────────────────────────────────────────────────────────
    p_train = subparsers.add_parser('train', help="Entraîne et sauvegarde le modèle.")
    p_train.add_argument(
        '--data',
        default='Données_V4.csv',
        help="Chemin vers le CSV de données (défaut : Données_V4.csv)",
    )

    # ── predict ────────────────────────────────────────────────────────────
    p_pred = subparsers.add_parser('predict', help="Prédit l'âge d'un arbre.")
    p_pred.add_argument('--tronc_diam',   type=float, help="Diamètre du tronc (cm)")
    p_pred.add_argument('--haut_tot',     type=float, help="Hauteur totale (m)")
    p_pred.add_argument('--haut_tronc',   type=float, help="Hauteur du tronc (m)")
    p_pred.add_argument('--clc_nbr_diag', type=int,   help="Nombre de diagnostics")
    p_pred.add_argument('--fk_stadedev',  type=str,   help="Stade de développement")
    p_pred.add_argument('--fk_situation', type=str,   help="Situation de l'arbre")
    p_pred.add_argument('--fk_port',      type=str,   help="Port de l'arbre")
    p_pred.add_argument('--fk_pied',      type=str,   help="Type de pied")
    p_pred.add_argument('--remarquable',  type=str,   help="Remarquable (Oui/Non)")
    p_pred.add_argument('--feuillage',    type=str,   help="Type de feuillage")

    return parser


# ══════════════════════════════════════════════════════════════════════════════
#  POINT D'ENTRÉE
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == '__main__':
    parser = build_parser()
    args   = parser.parse_args()

    if args.commande == 'train':
        cmd_train(args)
    elif args.commande == 'predict':
        cmd_predict(args)
