#' netcdfplot: Tools for plotting and analyzing NetCDF geospatial and temporal data
#'
#' Author: Sandra Isay Saad
#' \email{sandraisaad@gmail.com}
#' \href{https://orcid.org/0000-0002-4380-3175}{ORCID}
#'
#' The \pkg{netcdfplot} package provides a set of tools for loading, processing,
#' visualizing and analyzing georeferenced NetCDF data in R.
#'
#' It allows users to:
#' \itemize{
#'   \item Load NetCDF model outputs
#'   \item Extract spatial and temporal dimensions
#'   \item Visualize georeferenced variables
#'   \item Plot wind vector fields
#'   \item Compute spatial statistics
#'   \item Extract and visualize time series at specific coordinates
#' }
#'
#' The package is designed for atmospheric science and geoscience applications.
#'
#' @section Example workflow:
#'
#' \preformatted{
#'
#' # Load NetCDF file, extract dimensions and the desired variable
#' library(netcdfplot)
#'
#' arq <- gfs_example_file()     # Load example NetCDF file
#' gfs <- carrega_modelo(arq)
#'
#' longitudes <- carrega_longitude(gfs)
#' latitudes  <- carrega_latitude(gfs)
#' date       <- carrega_tempo(gfs)
#'
#' # Plot temperature map (time step 1) and compute maximum value within an area
#' shownames(gfs)
#'
#' temperature <- carrega_variavel(gfs, "tmp2m")
#'
#' temperature_t1 <- temperature[,,1]
#'
#' plota_mapa(
#'   temperature_t1,
#'   vlon = longitudes,
#'   vlat = latitudes,
#'   mapa_brasil = TRUE,
#'   mapa_amsul = TRUE,
#'   paleta = "YlGnBu"
#' )
#'
#' # Extract and plot time series at a specific location
#' coordx <- lon2x(longitudes, -46.5)
#' coordy <- lat2y(latitudes, -23.5)
#'
#' temperature_xy <- temperature[x = coordx, y = coordy, ]
#' df_temperature_xy <- data.frame(date, temperature_xy)
#'
#' plot(df_temperature_xy)
#'
#' #Plota o mapa do vento
#'u10m <- carrega_variavel(gfs, "ugrd10m");
#'v10m <- carrega_variavel(gfs, "vgrd10m");
#'
#'u10m_t1 <- u10m[,,1];
#'v10m_t1 <- v10m[,,1];
#'
#'plota_mapa_vento(u10m_t1,v10m_t1,vlon = longitudes, vlat = latitudes, mapa_brasil = T, mapa_amsul = T,skip = 3)
#'
#' }
#'
#' @docType package
#' @name netcdfplot
#' @keywords internal
"_PACKAGE"
