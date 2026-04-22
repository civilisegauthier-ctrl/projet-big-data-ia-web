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

ggplot(data) + 
  theme_classic() + #theme   theme_bw()
  aes(x = fk_stadedev)+
  geom_histogram(stat="count", fill="blue") #type


points_sf <- st_as_sf(
  data,
  coords = c("X", "Y"),
  crs = 3949
  )

arbres_sf = st_as_sf(
  data[!is.na(data4$X) & !is.na(data4$Y), ],
  coords = c("X", "Y"),
  crs    = 3949
)

arbres_sf = st_transform(arbres_sf, crs = 4326)
arbres_sf$lon = st_coordinates(arbres_sf)[, 1]
arbres_sf$lat = st_coordinates(arbres_sf)[, 2]


# 5. Carte leaflet

pal <- colorNumeric("Green", domain = data$haut_tot, na.color = "transparent",reverse = TRUE)

map <- leaflet(arbres_sf) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = 3.286, lat = 49.849, zoom = 13) %>%
  addCircleMarkers(
    lng = ~lon,
    lat = ~lat,
    radius = 6,
    color = ~pal(haut_tot)
  )

map

summary(arbres_sf)
data4= data%>% filter(!is.na(data$haut_tot) )

arbres_sf_remarque <- arbres_sf%>% filter(arbres_sf$remarquable== "Oui")

map2 <- leaflet(arbres_sf_remarque) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = 3.286, lat = 49.849, zoom = 13) %>%
  addCircleMarkers(
    lng = ~lon,
    lat = ~lat,
    radius = 6,
    color = ~pal(haut_tot)
)

map2
ggplot(data) + 
  theme_classic() + #theme   theme_bw()
  aes(x = clc_quartier)+
  geom_histogram(stat="count", fill="green") #type

ggplot(data) + 
  theme_bw() + #theme   
  aes(x = clc_quartier, y= haut_tot)+
  geom_point() + #type 
  geom_smooth(method=lm, se=FALSE) #lm: linear model 

ggplot(data) + 
  theme_bw() + #theme   
  aes(x = haut_tot, y= haut_tronc)+
  geom_point() + #type 
  geom_smooth(method=lm, se=FALSE) #lm: linear model 

data= data%>% filter(data$age_estim<2000)
ggplot(data) + 
  theme_bw() + #theme   
  aes(x = age_estim, y= haut_tot)+
  geom_point() + #type 
  geom_smooth(method=lm, se=FALSE) #lm: linear model 

ggplot(data) + 
  theme_bw() + #theme   
  aes(x = age_estim, y= haut_tronc)+
  geom_point() + #type 
  geom_smooth(method=lm, se=FALSE) #lm: linear model 


ggplot(data) + 
  theme_classic() + #theme   theme_bw()
  aes(x = clc_quartier,)+
  geom_histogram(stat="count", fill="blue") #type

ggplot(data) + 
  theme_classic() + #theme   theme_bw()
  aes(x = fk_situation,)+
  geom_histogram(stat="count", fill="blue") #type

