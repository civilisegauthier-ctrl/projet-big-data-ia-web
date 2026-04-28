########## import des bibliothèques et lecture du dataset ###########

from pathlib import Path
import sys

import pandas as pd
import plotly.express as px
from pyproj import CRS, Transformer


BASE_DIR = Path(__file__).resolve().parent
DATASET_PATH = BASE_DIR / 'dataset_ajuste.csv'

dataset = pd.read_csv(DATASET_PATH)

crs_3949 = CRS('EPSG:3949')
crs_latlon = CRS('EPSG:4326')
transformer = Transformer.from_crs(crs_3949, crs_latlon, always_xy=True)
longitudes, latitudes = transformer.transform(dataset['X'].values, dataset['Y'].values)

dataset['longitude'] = longitudes
dataset['latitude'] = latitudes

center_latitude = float(dataset['latitude'].mean())
center_longitude = float(dataset['longitude'].mean())


def apply_marker_style(fig):
    fig.update_traces(
        below='',
        marker=dict(
            opacity=0.95
        )
    )
    return fig


def predict_tree_size(cluster_count, tree_height):
    trouve = False

    for i in range(len(dataset)):
        if dataset.loc[i, 'haut_tot'] == tree_height:
            trouve = True

            if cluster_count == "3":
                if dataset.loc[i, 'cluster_taille3'] == "petit":
                    return "Cet arbre est petit."
                elif dataset.loc[i, 'cluster_taille3'] == "moyen":
                    return "Cet arbre est moyen."
                elif dataset.loc[i, 'cluster_taille3'] == "grand":
                    return "Cet arbre est grand."

            elif cluster_count == "2":
                if dataset.loc[i, 'cluster_taille2'] == "petit":
                    return "Cet arbre est petit."
                elif dataset.loc[i, 'cluster_taille2'] == "grand":
                    return "Cet arbre est grand."

    if not trouve:
        if cluster_count == "3":
            if tree_height > 18:
                return "Ce nouvel arbre est grand."
            elif tree_height < 11:
                return "Cet arbre est petit."
            else:
                return "Ce nouvel arbre est moyen."

        elif cluster_count == "2":
            if tree_height > 11:
                return "Ce nouvel arbre est grand."
            else:
                return "Ce nouvel arbre est petit."

    return "Prediction impossible."


############ interaction avec l'utilisateur ##############

#on initialise une variable qui va retenir le choix du client entre voir à quelle catégorie appartient un arbre ou voir la carte
#choix_init = input("souhaitez vous savoir à quel cluster appartient un arbre ou voir la carte qui répertorie les arbres ?\n Tapez 1 pour l'arbre, tapez 2 pour la carte.")
choix_init = sys.argv[1]

#si le choix n'est pas dans les options on demande au client de mettre un choix valide jusqu'à ce qu'il le fasse
"""
while choix_init != "1" and choix_init != "2":
  print("choix non valide. Choix possibles : 1 et 2")
  choix_init = input("souhaitez vous savoir à quel cluster appartient un arbre ou voir la carte qui répertorie les arbres ?\n Tapez 1 pour l'arbre, tapez 2 pour la carte.")
"""
  
#on demande au client s'il préfère avoir 2 catégories ou 3
if choix_init == "1":
  choix_nb_cluster = sys.argv[2]
  choix_taille = sys.argv[3]
  choix_taille_num = int(float(choix_taille))
  print(predict_tree_size(choix_nb_cluster, choix_taille_num))
#on créer la carte intéractive en fonction du nombre de catégorie demandée

elif choix_init=="2":
  """
  choix_nb_cluster = input("Préférez-vous voir 2 ou 3 cluster ?\n choix possible : 2 ou 3 ")
  while choix_nb_cluster != "2" and choix_nb_cluster != "3":
    print("choix non valide.","\n", "Choix possibles : 2 et 3 ")
    choix_nb_cluster = input("Combien de cluster voulez-vous ?\n choix possible : 2 ou 3")
    """
  choix_nb_cluster = sys.argv[2]
  if choix_nb_cluster =="2":
    fig = px.scatter_map(
        dataset,
        lat='latitude',
        lon='longitude',
        color='cluster_taille2',
        hover_data=['nomfrancais', 'haut_tot', 'remarquable'],
        zoom=12
    )
    fig.update_layout(
        map_style='open-street-map',
        map=dict(
            center=dict(lat=center_latitude, lon=center_longitude),
            zoom=12
        ),
        margin=dict(l=0, r=0, t=0, b=0)
    )
    fig = apply_marker_style(fig)
    print(fig.to_html(full_html=True, include_plotlyjs='cdn'))
  elif choix_nb_cluster =="3":
    fig = px.scatter_map(
        dataset,
        lat='latitude',
        lon='longitude',
        color='cluster_taille3',
        hover_data=['nomfrancais', 'haut_tot', 'remarquable'],
        zoom=12
    )
    fig.update_layout(
        map_style='open-street-map',
        map=dict(
            center=dict(lat=center_latitude, lon=center_longitude),
            zoom=12
        ),
        margin=dict(l=0, r=0, t=0, b=0)
    )
    fig = apply_marker_style(fig)
    print(fig.to_html(full_html=True, include_plotlyjs='cdn'))
