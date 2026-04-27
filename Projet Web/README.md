# Projet Web - Base de travail

Cette proposition fournit une premiere version simple du site web pour le projet :
`Concevoir et developper une application de gestion du patrimoine arbore : preuve de concept pour la ville de Saint-Quentin`.

## Fonctionnalites deja posees

- Une page d'accueil chargee par defaut avec menu de navigation
- Une page `Ajouter un arbre`
- Un formulaire qui demande uniquement les champs attendus
- Un chargement des listes depuis `Données_V4.csv`
- Des echanges AJAX entre le front-end et le back-end
- Des reponses JSON cote PHP

## Important

Pour le moment, il n'y a pas encore la vraie base MySQL ou PostgreSQL.
En attendant vos scripts SQL, les nouvelles saisies sont stockees dans :

- `Projet Web/data/arbres_ajoutes.json`

Le code a ete prepare pour etre facile a remplacer ensuite par des requetes SQL.

## Fichiers principaux

- `index.php` : page d'accueil
- `ajouter-arbre.php` : page contenant le formulaire
- `api/options.php` : retourne les choix du formulaire en JSON
- `api/ajouter_arbre.php` : recoit les donnees du formulaire en JSON
- `inc/data_utils.php` : fonctions PHP simples pour lire le CSV, valider et sauvegarder

## Charte graphique proposee

### Couleurs

- Vert fonce `#274c3a` pour rappeler le feuillage et la stabilite
- Vert moyen `#4d7c57` pour les boutons et elements actifs
- Vert clair `#ddebdc` pour l'ambiance naturelle
- Beige sable `#f5efe4` pour evoquer la terre et adoucir l'interface
- Brun ecorce `#7a5c43` pour les petits accents visuels

### Ombres

- Ombres douces et larges : `0 14px 30px rgba(39, 76, 58, 0.12)`
- Objectif : donner un aspect propre, moderne et rassurant sans effet trop fort

### Police de caracteres

- `Trebuchet MS`, puis `Verdana`, puis `sans-serif`
- Choix volontairement simple, lisible et facile a justifier pour un projet etudiant

## Lancer le projet en local

Exemple avec PHP :

```bash
php -S localhost:8000 -t "Projet Web"
```

Puis ouvrir :

- `http://localhost:8000`

## Remarque sur les donnees

Le fichier source contient surtout des valeurs comme :

- `EN PLACE`, `ABATTU`, `ESSOUCHE`, `REMPLACÉ` pour l'etat
- `Adulte`, `Jeune`, `Vieux`, `Senescent` pour le stade
- differents types de port et de pied directement repris dans le formulaire

Le champ espece est alimente a partir de la colonne `nomfrancais` du fichier fourni.
