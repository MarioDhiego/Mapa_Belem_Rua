
#------------------------------------------------------------------------------#
# Pacotes para Ler Shapefile
library(sf)
library(ggplot2)
library(leaflet)
library(leaflet.extras)
library(dplyr)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
#Limpa a Area de Trabalho
rm(list = ls()) 

# Definir o Diretorio de Trabalho
setwd("C:/Users/usuario/Documents/Shapefile_Belém_2022")

# Ler o shapfile
Belem_shape <- st_read('Belem_1501402_faces_de_logradouros_2022.shp',
                       options = "ENCODING=UTF-8")

# Calcular o centróide de cada polígono
belem_centroids <- st_centroid(Belem_shape)

# Extrair coordenadas
coords <- st_coordinates(belem_centroids)

# Selecione a variável de interesse (aqui usamos uma de exemplo)
# Substitua 'NOME_DA_VARIAVEL' por uma variável que represente a intensidade (ex: população, ocorrências, etc.)
# Veja as colunas com: names(belem_shape)

# Exemplo com uma variável genérica:
belem_centroids$TOT_RES <- 2 # Substitua por uma coluna real se desejar


#------------------------------------------------------------------------------#
# Mapa Belem - Rua
# Paleta de cores: mais escuro = valor maior
pal <- colorQuantile(
  palette = "YlOrRd",
  domain = Belem_shape$TOT_GERAL,
  n = 6,  # número de faixas
  na.color = "transparent"
)

# Mapa com ruas coloridas
leaflet(Belem_shape) %>%
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addPolygons(
    color = ~pal(TOT_GERAL),      # cor da borda baseada no valor
    weight = 4,                   # espessura da linha
    fillColor = ~pal(TOT_GERAL),  # cor de preenchimento baseada no valor
    fillOpacity = 1,              # opacidade do preenchimento
    popup = ~paste("Vitimas:", TOT_GERAL), # mostrar valor ao clicar
    highlightOptions = highlightOptions(
      color = "blue",       # cor ao passar o mouse
      weight = 5,           # espessura ao passar o mouse
      bringToFront = TRUE   # traz pra frente quando focado
    )  
    ) %>%
  addLegend("bottomright", 
            pal = pal, 
            values = ~TOT_GERAL,
            title = "Sinistros", 
            opacity = 1) %>%
  setView(lng = median(coords[,1]), 
          lat = median(coords[,2]), 
          zoom = 11)
#------------------------------------------------------------------------------#





























#------------------------------------------------------------------------------#
# Heatmap
leaflet(belem_centroids) %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  setView(lng = -48.4891, 
          lat = -1.4558, zoom = 14)  %>% # Ex: centro de Belém
  addHeatmap(
    lng = coords[,1],
    lat = coords[,2],
    intensity = belem_centroids$TOT_RES,
    blur = 15,
    radius = 12,
    max = max(belem_centroids$TOT_RES, na.rm = TRUE)
  )
#------------------------------------------------------------------------------#
leaflet(belem_centroids, options = leafletOptions(maxZoom = 18)) %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  fitBounds(
    lng1 = min(coords[,1]), lng2 = max(coords[,1]),
    lat1 = min(coords[,2]), lat2 = max(coords[,2])
  ) %>%
  addHeatmap(
    lng = coords[,1],
    lat = coords[,2],
    intensity = belem_centroids$TOT_RES,
    blur = 15,
    radius = 10,
    max = max(belem_centroids$TOT_RES, na.rm = TRUE)
  )
#------------------------------------------------------------------------------#









#------------------------------------------------------------------------------#
















