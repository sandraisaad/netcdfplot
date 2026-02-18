# netcdfplot

Tools for plotting and analyzing NetCDF geospatial and temporal data in R.

**Author:** Sandra I. Saad\
**Contact:** sandraisaad@gmail.com\
[Lattes CV](http://lattes.cnpq.br/0103102694865890)
[ORCID](https://orcid.org/0000-0002-4380-3175)

------------------------------------------------------------------------

## Overview

`netcdfplot` provides a set of tools to:

-   Load NetCDF model outputs
-   Extract spatial and temporal dimensions
-   Visualize georeferenced variables
-   Plot wind vector fields
-   Compute spatial statistics
-   Extract and visualize time series at specific coordinates

The package is designed for atmospheric and geoscience applications.

------------------------------------------------------------------------

## Installation

### From GitHub

``` r
install.packages("remotes")
remotes::install_github("sandraisaad/netcdfplot")
```

### From Bitbucket

``` r
remotes::install_bitbucket("sandraisaysaad/netcdfplot")
```

------------------------------------------------------------------------

## Dependencies

If not already installed, you may need:

``` r
install.packages(c(
  "ggplot2",
  "ncdf4",
  "sp",
  "metR",
  "RColorBrewer"
))
```

------------------------------------------------------------------------

## Example Workflow

### Load NetCDF file, extract dimensions and the desired variable

``` r

library("netcdfplot")

arq <- gfs_example_file()  		# Load the example file name
gfs  <- carrega_modelo(arq) 	# Or use your own Netcdf like gfs <- carrega_modelo("/data/gfs_2019092500.nc")

longitudes <- carrega_longitude(gfs)
latitudes  <- carrega_latitude(gfs)
date       <- carrega_tempo(gfs)

shownames(gfs)  # Show the variable names, so you can look for "temperature", for example

temperature <- carrega_variavel(gfs, "tmp2m")
```

------------------------------------------------------------------------

### Plot temperature map (time step 1) and compute maximum value within an area

``` r
temperature_t1 <- temperature[,,1]

plota_mapa(
  temperature_t1,
  vlon = longitudes,
  vlat = latitudes,
  mapa_brasil = TRUE,
  mapa_amsul = TRUE,
  paleta = "YlGnBu"
)

media_area(
  temperature_t1,
  mapa = "Brasil",
  vlat = latitudes,
  vlon = longitudes,
  fun = "max"
)
```

------------------------------------------------------------------------

### Extract and plot time series at a specific location

``` r
coordx <- lon2x(longitudes, -46.5)
coordy <- lat2y(latitudes, -23.5)

temperature_xy <- temperature[x = coordx, y = coordy, ]

df_temperature_xy <- data.frame(date, temperature_xy)

plot(df_temperature_xy)
```

------------------------------------------------------------------------

### Plot wind vector map

``` r
u10m <- carrega_variavel(gfs, "ugrd10m")
v10m <- carrega_variavel(gfs, "vgrd10m")

u10m_t1 <- u10m[,,1]
v10m_t1 <- v10m[,,1]

plota_mapa_vento(
  u10m_t1,
  v10m_t1,
  vlon = longitudes,
  vlat = latitudes,
  mapa_brasil = TRUE,
  mapa_amsul = TRUE,
  skip = 3
)
```

------------------------------------------------------------------------

## License

This project is licensed under the MIT License.
