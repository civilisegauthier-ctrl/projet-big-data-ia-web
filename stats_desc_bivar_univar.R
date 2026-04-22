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

#temp 
data= data%>% filter(data$age_estim<2000)

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

