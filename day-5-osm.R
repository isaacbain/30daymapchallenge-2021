# libraries ---------------------------------------------------------------
library(tidyverse)
library(sf)
library(mapview)
library(osmdata)

#OSM inspiration from http://joshuamccrain.com/tutorials/maps/streets_tutorial.html

# import data -------------------------------------------------------------

getbb("Atlanta Georgia")

big_streets <- getbb("Auckland") %>%
  opq()%>%
  add_osm_feature(key = "highway",
                  value = c("motorway", "primary", "motorway_link", "primary_link")) %>%
  osmdata_sf()

med_streets <- getbb("Auckland") %>%
  opq()%>%
  add_osm_feature(key = "highway",
                  value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) %>%
  osmdata_sf()

small_streets <- getbb("Auckland") %>%
  opq()%>%
  add_osm_feature(key = "highway",
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway"
                  )) %>%
  osmdata_sf()

aq <- read_csv("data/mfe-nitrogen-dioxide-concentrations-waka-kotahi-nzta-2007-2020-CSV/nitrogen-dioxide-concentrations-waka-kotahi-nzta-2007-2020.csv")

aq %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
  filter(region == "Auckland") %>%
  filter(!(site %in% c("AUC004a","AUC004b", "AUC004", "AUC070"))) %>%
  filter(year >= 2011) %>%
  filter(complete_year) %>%
  group_by(site) %>%
  summarise(annual_median_conc = median(concentration, na.rm = T)) %>%
  arrange(annual_median_conc) -> aq2

# plot --------------------------------------------------------------------

ggplot() +
  geom_sf(data = big_streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .5,
          alpha = .6) +
  geom_sf(data = med_streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .3,
          alpha = .5) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .2,
          alpha = .3) +
  geom_sf(data = aq2,
          size = 5,
          aes(colour = annual_median_conc)) +
  scale_colour_viridis_c() +
  theme_void()

# export ------------------------------------------------------------------

ggsave("outputs/day5.pdf", width = 297, height = 420, units = "mm")
