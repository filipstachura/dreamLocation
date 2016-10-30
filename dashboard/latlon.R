library(magrittr)
library(leaflet)
library(dplyr)

poziom <- seq(52.2, 52.27, by = 0.0025)
pion <- seq(20.95, 21.1, by = 0.005)

expand.grid(poziom, pion) %>%
  rename(lat = Var1, lon = Var2) -> punkty

leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(data = punkty)
