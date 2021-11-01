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

wq <- load_data(99867)


# plot --------------------------------------------------------------------

wq %>%
  filter(np_id == "NO3N") %>%
  st_as_sf(coords = c("nztme", "nztmn"), crs = 2193) %>%
  arrange(median) %>%
  ggplot() +
  geom_sf(aes(size = median,
              colour = median),
          alpha = 0.65,
          stroke = 0) +
  scale_size(range = c(1, 15),
             trans = "pseudo_log") +
  #scale_color_viridis_c() +
  scale_color_gradient(low = "#1d3153", high = "#74b493",
                       trans = "pseudo_log") +
  theme_void()


# export ------------------------------------------------------------------

ggsave("outputs/day1.pdf", width = 297, height = 420, units = "mm")

