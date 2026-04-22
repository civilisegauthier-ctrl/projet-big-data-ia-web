library(ggplot2)
library(AER)
library(dplyr)
library(tidyverse)
library(ggmap)
library(magrittr)
library(leaflet)
library(maps)
library(sf)


#définir le répertoire de travail attention il faut \\ pour le chemin ou /
setwd("/Users/gauthiercivilise/Documents/CIPA4/Projet_IA_WEB_DATA/projet-big-data-ia-web")

getwd()


data = read.csv2("Données_V4.csv",
                 header = TRUE,
                 fileEncoding = "UTF-8",
                 stringsAsFactors = FALSE,
                 sep = ';',
                 dec =',',
) #row.names = 1 pour transfo en index


############################################################
# 1. DESCRIPTION GÉNÉRALE DU JEU DE DONNÉES
############################################################

# Nombre de lignes et de colonnes
dim(data)

# Structure des variables
str(data)

# Résumé global du dataset
summary(data)

# Nombre de valeurs manquantes par variable
colSums(is.na(data))

############################################################
# 2. STATISTIQUES DESCRIPTIVES UNIVARIÉES
############################################################


# Variables quantitatives

# Hauteur totale
mean_haut <- mean(data$haut_tot, na.rm = TRUE)

median_haut <- median(data$haut_tot, na.rm = TRUE)

sd_haut <- sd(data$haut_tot, na.rm = TRUE)

min_haut <- min(data$haut_tot, na.rm = TRUE)

max_haut <- max(data$haut_tot, na.rm = TRUE)

# Diamètre du tronc
mean_diam <- mean(data$tronc_diam, na.rm = TRUE)

median_diam <- median(data$tronc_diam, na.rm = TRUE)

sd_diam <- sd(data$tronc_diam, na.rm = TRUE)

min_diam <- min(data$tronc_diam, na.rm = TRUE)

max_diam <- max(data$tronc_diam, na.rm = TRUE)

# Âge estimé
mean_age <- mean(data$age_estim, na.rm = TRUE)

median_age <- median(data$age_estim, na.rm = TRUE)

sd_age <- sd(data$age_estim, na.rm = TRUE)

min_age <- min(data$age_estim, na.rm = TRUE)

max_age <- max(data$age_estim, na.rm = TRUE)

############################
# Variables qualitatives
############################

# Répartition par état
table_etat <- table(data$fk_arb_etat)

prop_etat <- prop.table(table_etat) * 100

# Répartition par type de feuillage
table_feuillage <- table(data$feuillage)

prop_feuillage <- prop.table(table_feuillage) * 100

# Répartition arbres remarquables
table_remarquable <- table(data$remarquable)

prop_remarquable <- prop.table(table_remarquable) * 100

###################################################
# 3. STATISTIQUES DESCRIPTIVES BIVARIÉES
###################################################

# Quantitative / quantitative

# Corrélation âge / hauteur
cor_age_haut <- cor(
  data$age_estim,
  data$haut_tot,
  use = "complete.obs"
  )

# Corrélation diamètre / hauteur
cor_diam_haut <- cor(
  data$tronc_diam,
  data$haut_tot,
  use = "complete.obs"
)

############################
# Qualitative vs quantitative
############################

# Moyenne de hauteur par état

mean_haut_par_etat <- aggregate(
  haut_tot ~ fk_arb_etat,
  data = data,
  mean,
  na.rm = TRUE
)

# Moyenne de hauteur selon remarquable

mean_haut_remarquable <- aggregate(
  haut_tot ~ remarquable,
  data = data,
  mean,
  na.rm = TRUE
)

############################
# Qualitative vs qualitative
############################

# Tableau croisé feuillage / état

croise_feuillage_etat <- table(
  data$feuillage,
  data$fk_arb_etat
)

############################################################
# 4. AFFICHAGE DES RÉSULTATS
############################################################

mean_haut

median_haut

sd_haut

mean_diam

median_diam

sd_diam

mean_age

median_age

sd_age

table_etat

prop_etat

table_feuillage

prop_feuillage

table_remarquable

prop_remarquable

cor_age_haut

cor_diam_haut

mean_haut_par_etat

mean_haut_remarquable

croise_feuillage_etat













































###########################
# 1. DESCRIPTION GÉNÉRALE 
###########################

# Structure des variables

str(data)

# Résumé statistique global

summary(data)

# Dimensions : nombre de lignes et colonnes

dim(data)

# Nombre de valeurs manquantes par colonne

colSums(is.na(data))

###########################################
# 2. STATISTIQUES DESCRIPTIVES UNIVARIÉES
###########################################


# Variables quantitatives

# ---- Hauteur totale ----

summary(data$haut_tot)

sd(data$haut_tot, na.rm = TRUE)

# Histogramme

hist(
  
  data$haut_tot,
  
  main = "Distribution de la hauteur totale",
  
  xlab = "Hauteur (m)"
  
)

# Boxplot

boxplot(
  
  data$haut_tot,
  
  main = "Boxplot de la hauteur totale"
  
)

# ---- Diamètre du tronc ----

summary(data$tronc_diam)

sd(data$tronc_diam, na.rm = TRUE)

hist(
  
  data$tronc_diam,
  
  main = "Distribution du diamètre du tronc",
  
  xlab = "Diamètre (cm)"
  
)

boxplot(
  
  data$tronc_diam,
  
  main = "Boxplot du diamètre du tronc"
  
)

# ---- Âge estimé ----

data= data%>% filter(data$age_estim<2000)

summary(data$age_estim)

sd(data$age_estim, na.rm = TRUE)

boxplot(
  
  data$age_estim,
  
  main = "Boxplot de l'âge estimé"
  
)



# Variables qualitatives

# ---- État des arbres ----

table(data$fk_arb_etat)

# Pourcentage des états

prop.table(table(data$fk_arb_etat)) * 100

# Diagramme en barres

barplot(
  
  table(data$fk_arb_etat),
  
  main = "Répartition de l'état des arbres",
  
  las = 2
  
)

# ---- Type de feuillage ----

table(data$feuillage)

barplot(
  
  table(data$feuillage),
  
  main = "Répartition du feuillage"
  
)

# ---- Arbres remarquables ----

table(data$remarquable)

barplot(
  
  table(data$remarquable),
  
  main = "Arbres remarquables"
  
)

############################################
# 3. STATISTIQUES DESCRIPTIVES BIVARIÉES
############################################

############################
# Quantitative / quantitative
############################

# ---- Relation âge / hauteur ----

plot(
  
  data$age_estim,
  
  data$haut_tot,
  
  main = "Relation entre âge et hauteur",
  
  xlab = "Âge estimé",
  
  ylab = "Hauteur totale"
  
)

# Coefficient de corrélation

cor(
  
  data$age_estim,
  
  data$haut_tot,
  
  use = "complete.obs"
  
)

# ---- Relation diamètre / hauteur ----

plot(
  
  data$tronc_diam,
  
  data$haut_tot,
  
  main = "Relation diamètre / hauteur",
  
  xlab = "Diamètre du tronc",
  
  ylab = "Hauteur totale"
  
)

cor(
  
  data$tronc_diam,
  
  data$haut_tot,
  
  use = "complete.obs"
  
)

############################

# Qualitative / quantitative

############################

# ---- Hauteur selon l'état ----

boxplot(haut_tot ~ fk_arb_etat,data = data,main = "Hauteur selon l'état de l'arbre",las = 2)

# ---- Hauteur selon caractère remarquable ----

data$remarquable = replace_na("Non")

boxplot(haut_tot ~ remarquable,data = data,main = "Hauteur selon le caractère remarquable")


# ---- Top 10 des espèces ----

top_especes <- sort(table(data$nomfrancais), decreasing = TRUE)

barplot(top_especes[1:10],main = "Top 10 des espèces les plus présentes",las = 2)

