# Instructions pour le projet Big Data IA Web

## 1. Installation de GitHub sur Windows et Mac

### Windows  
1. Téléchargez le programme d'installation de Git pour Windows depuis [git-scm.com](https://git-scm.com/download/win).  
2. Ouvrez le fichier téléchargé et suivez les instructions à l'écran.  
3. Au moment de la configuration, il est recommandé de choisir les options par défaut.  
4. Une fois l'installation terminée, ouvrez l'invite de commande ou Git Bash pour vérifier l'installation en tapant `git --version`.  

### Mac  
1. Ouvrez le terminal.  
2. Si vous avez Homebrew installé, exécutez la commande suivante :  
   ```bash  
   brew install git  
   ```  
3. Sinon, vous pouvez télécharger le programme d'installation depuis [git-scm.com](https://git-scm.com/download/mac) et suivre les instructions.  
4. Vérifiez l'installation en tapant `git --version` dans le terminal.

## 2. Clonage du dépôt en local

### Windows  
1. Ouvrez l'invite de commande ou Git Bash.  
2. Naviguez vers le dossier où vous souhaitez cloner le dépôt en utilisant `cd <chemin_du_dossier>`.  
3. Clonez le dépôt avec la commande suivante :  
   ```bash  
   git clone https://github.com/civilisegauthier-ctrl/projet-big-data-ia-web.git  
   ```  

### Mac  
1. Ouvrez le terminal.  
2. Naviguez vers le dossier où vous souhaitez cloner le dépôt en utilisant `cd <chemin_du_dossier>`.  
3. Clonez le dépôt avec la commande suivante :  
   ```bash  
   git clone https://github.com/civilisegauthier-ctrl/projet-big-data-ia-web.git  
   ```  

## 3. Bonnes pratiques pour les débutants

- **Garder le code à jour** : Avant de commencer à travailler, exécutez `git pull` pour récupérer les dernières modifications du dépôt distant.
- **Effectuer des commits fréquents** : Commitez vos changements régulièrement avec des messages clairs. Utilisez la commande :  
   ```bash  
   git commit -m "Votre message de commit"  
   ```  
- **Pousser les changements** : Une fois que vous avez commité vos modifications, poussez-les vers le dépôt distant avec :  
   ```bash  
   git push origin main  
   ```  

- **Utiliser des branches** : Pour de nouvelles fonctionnalités, créez une nouvelle branche avec :  
   ```bash  
   git checkout -b votre-nouvelle-branche  
   ```  
- **Lister vos branches** : Pour voir toutes les branches, utilisez :  
   ```bash  
   git branch  
   ```  

- **Fusionner des branches** : Une fois le travail terminé, changez de branche vers `main` et fusionnez votre branche :  
   ```bash  
   git checkout main  
   git merge votre-nouvelle-branche  
   ```  

Ces étapes vous aideront à gérer votre code et à collaborer efficacement sur le projet.