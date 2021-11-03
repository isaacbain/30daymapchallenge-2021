# libraries ---------------------------------------------------------------
library(tidyverse)
library(sf)
library(mapview)

# import data -------------------------------------------------------------

dat <- st_read("data/mfe-marine-reserves-SHP/marine-reserves.shp")

coastline <- st_read("data/lds-nz-coastlines-and-islands-polygons-topo-1500k-SHP/nz-coastlines-and-islands-polygons-topo-1500k.shp") %>%
  st_simplify(dTolerance = 100)

dat <- dat %>%
  mutate(Name = tm::removeWords(Name, c("Marine ", "Reserve")))

# plot --------------------------------------------------------------------

g <- purrr::map(unique(dat$Name),
                function(x) {

                  # subset data
                  temp_sf <- subset(dat, Name == x)

                  ggplot() +
                    geom_sf(data = temp_sf,
                            fill = '#006994',
                            lwd = 0) +
                    ggtitle(str_wrap(x, width = 10)) +
                    theme_void()
                })

g2 <- cowplot::plot_grid(plotlist = g,
                         label_size = 2,
                         scale = 0.75)
g2

# export ------------------------------------------------------------------

ggsave("outputs/day3.pdf", width = 297, height = 420, units = "mm")
