library(viridis)
library(sf)
library(ggplot2)
library(tmap)
library(tmaptools)
library(leaflet)
library(dplyr)
library(rgeos)
library(maptools)
library(rgdal)
library(spData)

### load map info ###
mymap <- st_read("NZ Map/statistical-area-2-2021-clipped-generalised.shp",
                 stringsAsFactors = TRUE)

# plot to ensure that this is the right area breakdown
ggplot() +
  geom_sf(data = mymap, aes(fill = )) +
  # make sure that the coordinate system is properly trimmed, otherwise this plot goes around the entire globe...
  coord_sf(xlim = c(165, 179), ylim = c(-47, -34)) #+

# load mite data from mite data wrangling output file
mites <- readr::read_csv("mite_data_mite_monitor13July2021.csv") %>% 
  dplyr::select(!X1)

mites <- mites[,c("longitude", "latitude", "beekeeper", "apiary", "date", "year", "month", "hive", "mite_count", "treatment", "moved_to")]

# convert to spatial object with attributes
coordinates(mites) <- ~longitude + latitude
# assign coordinate system
proj4string(mites) <- proj4string(CRS("EPSG:4326"))

# IN ORDER TO DO SO:
# extract crs information from mymap to be able to use it for defining the point geometries of mite observations
st_crs(mymap)

# the output looks like this, the bit we want is the "ID" at the very bottom, in this case "EPSG:4326"
#Coordinate Reference System:
#  User input: WGS 84 
#wkt:
#  GEOGCRS["WGS 84",
#          DATUM["World Geodetic System 1984",
#                ELLIPSOID["WGS 84",6378137,298.257223563,
#                          LENGTHUNIT["metre",1]]],
#          PRIMEM["Greenwich",0,
#                 ANGLEUNIT["degree",0.0174532925199433]],
#          CS[ellipsoidal,2],
#          AXIS["latitude",north,
#               ORDER[1],
#               ANGLEUNIT["degree",0.0174532925199433]],
#          AXIS["longitude",east,
#               ORDER[2],
#               ANGLEUNIT["degree",0.0174532925199433]],
#          ID["EPSG",4326]]


# this SpatialPointsDataFrame "mites" object now contains all the information we need..

#... to check if the points are inside the geometries in the map
mites$SA22021__1 <- as.vector(over(mites, as_Spatial(mymap)) %>% dplyr::select(SA22021__1))
mites$SA22021__1 <- mites$SA22021__1$SA22021__1

count <- mites@data %>% group_by(SA22021__1, year, month) %>% summarise(count = mean(mite_count))
colnames(count) <- c("SA22021__1", "year", "month", "count")
areas <- as.data.frame(mymap[["SA22021__1"]])
colnames(areas) <- "SA22021__1"
mite_count <- left_join(areas, count %>% dplyr::filter(year == 2021 & as.numeric(month) == 05),
                              by = "SA22021__1")
  

mymap[["Count"]] <- mite_count$count

# plot
ggplot() +
  geom_sf(data = mymap, aes(fill = Count)) +
  # cut back to Canterbury
  coord_sf(xlim = c(170, 174), ylim = c(-44.6, -43.5)) +
  scale_fill_gradient(low = "greenyellow", high = "firebrick3")
