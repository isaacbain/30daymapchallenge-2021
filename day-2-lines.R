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

wq <- load_data(99871)


coastline <- st_read("data/lds-nz-coastlines-and-islands-polygons-topo-1500k-SHP/nz-coastlines-and-islands-polygons-topo-1500k.shp") |>
  st_simplify(dTolerance = 500)


# plot --------------------------------------------------------------------


