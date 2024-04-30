library(tidyverse)
library(sf)
library(osmdata)


# NTPU ----
bbox <- c(121.3571, 24.9497, 121.3783, 24.9367)

NTPU <- opq(bbox) %>% 
  add_osm_feature(key = "name", value = "國立臺北大學")
NTPU2 <- osmdata_sf(NTPU)

# NTPU buding ----
query <- opq(bbox) %>% 
  add_osm_feature(key = "building", value = "university")

osmdata <- osmdata_sf(query)

uni_build <- 
osmdata[["osm_polygons"]] %>% 
  filter(name %in% c("公共事務大樓", "法學大樓", "社會科學大樓", 
                     "人文大樓", "商學大樓", "音律電資大樓")
         )

subject_colors <- c("公共事務大樓" = "#FFD06F",
                    "法學大樓" = "#376795",
                    "社會科學大樓" = "#72BCD5",
                    "人文大樓" = "#84A8CA",
                    "商學大樓" = "black",
                    "音律電資大樓" = "red")

# draw ----

ggplot() +
  geom_sf(
    data = NTPU2[["osm_polygons"]]
  ) +
  geom_sf(
    data = uni_build, fill = subject_colors,
  )