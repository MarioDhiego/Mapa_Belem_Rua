

# Pacotes para Ler Shapefile
library(sf)
library(ggplot2)
library(leaflet)
library(leaflet.extras)
library(dplyr)

#Limpa a Area de Trabalho
rm(list = ls()) 


# Definir o Diretorio de Trabalho
setwd("C:/Users/usuario/Documents/Shapefile_Belém_2022")

# Ler o shapfile
Belem_shape <- st_read('Belem_1501402_faces_de_logradouros_2022.shp',
                       options = "ENCODING=UTF-8")

~
  
# Definir um limiar para os maiores valores (80º percentil)
limiar <- quantile(Belem_shape$TOT_GERAL, 0.80, na.rm = TRUE)

# Filtrar apenas as regiões com valores acima do limiar
Belem_top <- Belem_shape %>% filter(TOT_GERAL >= limiar)

# Verificar os valores filtrados
summary(Belem_top$TOT_GERAL)




head(Belem_shape)


ggplot(data = Belem_shape) +
  geom_sf(fill = "white", color = "black") +
  theme_minimal() +
  ggtitle("Mapa de Belém - Faces de Logradouros")

ggplot(data = Belem_shape) +
  geom_sf(aes(fill = TOT_GERAL), color = "black") +
  scale_fill_viridis_c(option = "magma", na.value = "grey80") +  # Melhorando as cores
  theme_minimal() +
  ggtitle("Mapa de Belém - TOT_GERAL por Região")




ggplot(Belem_shape) +
  geom_sf(aes(fill = TOT_GERAL), color = "black") +
  scale_fill_gradient(low = "yellow", high = "red", na.value = "grey80") +
  theme_minimal() +
  ggtitle("Mapa de Calor - TOT_GERAL em Belém")


leaflet(Belem_shape) %>%
  addTiles() %>%
  addPolygons(fillColor = "blue", color = "black", weight = 1, opacity = 1)


pal <- colorNumeric("viridis", domain = Belem_shape$TOT_GERAL)

leaflet(Belem_shape) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(TOT_GERAL), 
              color = "black", 
              weight = 1, 
              opacity = 1,
              fillOpacity = 0.7,
              popup = ~paste("Valor:", TOT_GERAL)) %>%
  addLegend(pal = pal, values = Belem_shape$TOT_GERAL, title = "TOT_GERAL")



leaflet(Belem_shape) %>%
  addTiles() %>%
  addHeatmap(lng = ~st_coordinates(Belem_shape)[,1], 
             lat = ~st_coordinates(Belem_shape)[,2], 
             intensity = ~TOT_GERAL, 
             blur = 20, max = 0.05, radius = 15) %>%
  addLegend(pal = colorNumeric("viridis", domain = Belem_shape$TOT_GERAL), 
            values = Belem_shape$TOT_GERAL, 
            title = "TOT_GERAL")



leaflet(Belem_top) %>%
  addTiles() %>%
  addHeatmap(lng = ~st_coordinates(Belem_top)[,1], 
             lat = ~st_coordinates(Belem_top)[,2], 
             intensity = ~TOT_GERAL, 
             blur = 20, max = 0.05, radius = 15) %>%
  addLegend(pal = colorNumeric("viridis", domain = Belem_top$TOT_GERAL), 
            values = Belem_top$TOT_GERAL, 
            title = "TOT_GERAL (Maiores Valores)")



