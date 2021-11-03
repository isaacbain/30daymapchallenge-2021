# libraries ---------------------------------------------------------------
library(tidyverse)
library(sf)
library(mapview)

# import data -------------------------------------------------------------

dat <- st_read("data/livestock-numbers-grid-aps-2017/livestock-numbers-grid-aps-2017.shp")


# plot --------------------------------------------------------------------

my_breaks = c(0, 25000, 50000, 75000, 100000)

p1 <- dat %>%
  ggplot() +
  geom_sf(aes(fill = cattle),
          colour = "white",
          size = 0.01) +
  scale_fill_viridis(breaks = my_breaks, limits = c(0, 100000)) +
  theme_void()

p2 <- dat %>%
  ggplot() +
  geom_sf(aes(fill = beef),
          colour = "white",
          size = 0.01) +
  scale_fill_viridis(breaks = my_breaks, limits = c(0, 100000)) +
  theme_void()

p3 <- dat %>%
  ggplot() +
  geom_sf(aes(fill = dairy),
          colour = "white",
          size = 0.01) +
  scale_fill_viridis(breaks = my_breaks, limits = c(0, 100000)) +
  theme_void()

p2 + p1 + p3


# export ------------------------------------------------------------------

ggsave("outputs/day4.pdf", width = 297, height = 420, units = "mm")
