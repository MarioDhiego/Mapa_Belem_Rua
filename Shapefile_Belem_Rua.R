

# Pacotes para Ler Shapefile
library(sf)
library(ggplot2)

#Limpa a Area de Trabalho
rm(list = ls()) 

# Definir o Diretorio de Trabalho
setwd("C:/Users/usuario/Documents/Shapefile_Belém_2022")

# Ler o shapfile
Belem_shape <- st_read('Belem_1501402_faces_de_logradouros_2022.shp')


head(Belem_shape)


ggplot(Belem_shape) +
  geom_sf(fill = "White")+
  theme_grey()













