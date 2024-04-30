library(tidyverse)
library(sf)

shopeData <- st_read("240423/mapdata202301070205/COUNTY_MOI_1090820.shp")

glimpse(shopeData)

# 簡化圖形 ----
simplified_shape <- st_simplify(shopeData,
                                preserveTopology = TRUE,
                                dTolerance = 5)
object.size(simplified_shape)

ggplot() +
  geom_sf(
    data = simplified_shape
  )

# 修改邊界 ----
bbox <- st_bbox(simplified_shape)
bbox

bbox["ymin"] <- 21

simplified_shape <- 
  st_crop(simplified_shape, # 直接串接
          bbox)


# 只選新北市 ----
simplified_shape2 <- 
  simplified_shape |>
    filter(COUNTYNAME == "新北市")

ggplot() +
  geom_sf(
    data = simplified_shape2
  )


# Creating a column "zone" with random assignment ----
set.seed(123)  # Setting seed for reproducibility
simplified_shape <- simplified_shape %>%
  mutate(zone = sample(c("north", "south", "east", "west"), size = n(), replace = TRUE))
glimpse(simplified_shape)

ggplot()+
  geom_sf(
    data=simplified_shape,
    mapping=aes(
      fill=zone
    )
  )

# Plotting simplified_shape with filled color determined by zone column -----
plot <- ggplot(simplified_shape) +
  geom_sf(aes(fill = zone)) +
  theme_minimal() +
  scale_fill_manual(values = c("north" = "blue", "south" = "green", "east" = "red", "west" = "yellow")) +
  labs(title = "Simplified Shape with Zone Coloring", subtitle = "Zone") +
  theme(legend.position = "bottom") +
  theme(legend.title = element_blank()) +
  theme(legend.text = element_text(size = 8)) +
  theme(axis.line.x = element_line(color = "black", size = 0.5)) +
  labs(caption = "Data Source: your_source")




