# libraries ---------------------------------------------------------------
library(tidyverse)
library(sf)
library(mapview)

# import data -------------------------------------------------------------

Sys.getenv("YOUR_API_TOKEN")
#Import the data from MfE Data Service
load_data <- function (x) {
  if ("YOUR_API_TOKEN" %in% names(Sys.getenv())) {
    st_read(paste0(paste0("https://data.mfe.govt.nz/services;key=",
                          Sys.getenv("YOUR_API_TOKEN"), #Loads your API token
                          "/wfs/table-"),
                   x,
                   "?service=WFS&request=GetCapabilities"), as_tibble = TRUE) %>%
      readr::type_convert() # Re-defines column types as they are all read in as characters initially
  } else {
    print("YOUR_API_TOKEN (MfE Data Service API token) not loaded as enviroment variable, see https://gist.github.com/CarlaGC/a39217565504dc2c3051178f9259fc95")
  }
}

#wq <- load_data(99871)

load("data/rec2.Rdata")
wq <- read_csv("data/mfe-river-water-quality-modelled-state-20132017-CSV/river-water-quality-modelled-state-20132017.csv")

rec2_joined <- rec2 %>%
  left_join(wq %>% filter(np_id == "MCI"), "nzsegment")

coastline <- st_read("data/lds-nz-coastlines-and-islands-polygons-topo-1500k-SHP/nz-coastlines-and-islands-polygons-topo-1500k.shp") %>%
  st_simplify(dTolerance = 500)


# plot --------------------------------------------------------------------

rec2_joined %>%
  #filter(Region == "Northland Region") %>%
  filter(Region %in% c("Northland Region",
                       "Auckland Region",
                       "Waikato Region",
                       "Bay of Plenty Region",
                       "Gisborne Region",
                       "Manawatu-Wanganui Region",
                       "Hawke's Bay Region",
                       "Taranaki Region",
                       "Wellington Region")) %>%
  filter(StreamOrde > 1) %>%
  arrange(CUM_AREA) %>%
  ggplot() +
  geom_sf(data = coastline %>% filter(stringr::str_detect(name, "North Island or Te")),
          fill = NA,
          colour = "white",
          size = 0.25) +
  geom_sf(aes(colour = median,
              size = CUM_AREA),
          lineend = "round",
          linejoin = "bevel") +
  scale_size(range = c(0.01, 0.5), trans = "log10") +
  scale_colour_viridis_c(direction = -1, option = "C") +
  theme_void()

# export ------------------------------------------------------------------

ggsave("outputs/day2.pdf", width = 297, height = 420, units = "mm")
