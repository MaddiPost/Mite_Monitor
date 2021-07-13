#AWESOME: https://www.youtube.com/watch?v=GMi1ThlGFMo

#Visual appeal: https://www.youtube.com/watch?v=nlcZcWJiyX8
#https://community.rstudio.com/t/trouble-with-showing-centroids-using-plot-function/64431/2

####GERTJE

mymap <- st_read("NZ Map/statistical-area-2-2021-clipped-generalised.shp",
                 stringsAsFactors = TRUE)

cent_nz <- st_centroid(st_geometry(nz))  
nz$geom2 = st_centroid(st_geometry(nz))


ggplot() +
  geom_sf(data = mymap, aes(fill = )) +
  coord_sf(xlim = c(150.97, 180), ylim = c(-33.98, -33.79)) +
  geom_sf(data = cent_nz, pch = 16, cex = 4, bg = "red", color = "red") 


ggplot() +
  geom_sf(data = mymap, aes(fill = )) +
  theme_bw() +
  coord_sf(xlim = c(150.97, 180), ylim = c(-33.98, -.79)) +
  geom_sf(data = cent_nz)

#create fake mite data
Count <- ceiling(rnorm(2176, mean = 1.5, sd = 1.5))
Count[(which(Count < 0))] <- 0
mymap[["Count"]] <- Count


#Coding ettiquette: call data something meaningful! And dont use anyone elses info.


install.packages("sf")
install.packages("ggplot2")
install.packages("tmap")
install.packages("tmaptools")
install.packages("leaflet")
install.packages("dplyr")
install.packages("sp")
install.packages("rgeos")
install.packages("maptools")
install.packages("rgdal")
install.packages("spData")

library(viridis)
library(sf)
library (ggplot2)
library(tmap)
library (tmaptools)
library (leaflet)
library (dplyr)
library(rgeos)
library(maptools)
library(rgdal)
library(spData)

options(scipen = 999)



mymap1 <- st_read("NZ Map/new_zealand_administrative_boundaries_province_polygon.shp",
                 stringsAsFactors = TRUE)

cent_nz <- st_centroid(st_geometry(mymap))  
nz$geom2 = st_centroid(st_geometry(nz))

ggplot() +
  geom_sf(data = mymap, aes(fill = )) +
  coord_sf(xlim = c(150.97, 180), ylim = c(-33.98, -33.79)) +
  geom_sf(data = cent_nz, pch = 16, cex = 4, bg = "red", color = "red") 


ggplot() +
  geom_sf(data = mymap, aes(fill = )) +
  theme_bw() +
  coord_sf(xlim = c(150.97, 180), ylim = c(-33.98, -33.79)) +
  geom_sf(data = cent_nz)




####################################



mymap <- st_read("new_zealand_administrative_boundaries_province_polygon.shp",
                 stringsAsFactors = TRUE)


mymap2 <- sf::st_read("new_zealand_administrative_boundaries_province_polygon.shp")

str(mymap)
mydata <- readr::read_csv("RegionMiteMock.csv")

map_and_data <- inner_join(mymap, mydata) #need common key column
str(map_and_data)

ggplot(map_and_data) +
  geom_sf(aes(fill = MiteLevel))


#add colours for scale:
ggplot(map_and_data) +
  geom_sf(aes(fill = MiteLevel))+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43")

#using tmap: more attractive 

tm_shape(map_and_data) +
  tm_polygons("MiteLevel",  id = "name", palette = "plasma")

#make interactive java script map!!!

tmap_mode("plot") #plot for non-interactive
tmap_last()

Map1 <- tmap_last()
tmap_save(Map1, "Map1.html")


###################### Use Centroid 
library(sf)
library(spData)


mymap <- st_read("new_zealand_administrative_boundaries_province_polygon.shp",
                 stringsAsFactors = TRUE)

cent_nz <- st_centroid(st_geometry(mymap))  
nz$geom2 = st_centroid(st_geometry(nz))

ggplot() +
  geom_sf(data = nz, aes(fill = )) +
  geom_sf(data = cent_nz, pch = 16, cex = 4, bg = "red", color = "red") 




mymap2 <- readShapePoly("new_zealand_administrative_boundaries_province_polygon.shp")

str(mymap)
mydata <- readr::read_csv("RegionMiteMock.csv")

centr <- SpatialPointsDataFrame(centr, data= mymap2@data) 


#plot(centr["name"])




cent_nz <- st_centroid(st_geometry(mymap))  
nz$geom2 = st_centroid(st_geometry(nz))


#centr <- SpatialPointsDataFrame(centr, data= mymap2@data) 

# base solution
#plot(mymap["name"])
#plot(centr, pch = 1, col = "red", cex = 2, add = T)

# tidyverse solution
library(ggplot2)

ggplot() +
  geom_sf(data = nz, aes(fill = )) +
  geom_sf(data = cent_nz, pch = 16, cex = 4, bg = "red", color = "red")  


tmap_mode("plot") #plot for non-interactive


#####################################################
centr <- gCentroid(mymap2, byid = TRUE)

# create SpatialPointsDataFrame to export via writeOGR
# positive side effect: All data from landuse@data joined to centr@data

centr <- SpatialPointsDataFrame(centr, data= mymap2@data) 

writeOGR(centr, ".", "region_centroids", driver = "ESRI Shapefile")

plot(centr["name"]) #gives the center points for all "names" aka regionss

plot(centr, pch=4, col="red", add=T)


ggplot() +
  geom_sf(data = mydata, aes(fill = MiteLevel)) +
  geom_sf(data = centr, pch = 4, color = "red")  


