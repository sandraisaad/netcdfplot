#' netcdfplot
#'
#' Ferramentas para plotar e analisar dados em Netcdf
#'
#' Sandra I. Saad
#' sandraisaad@@gmail.com
#'
#' @section Exemplos:
#'
#' #Carrega o arquivo do Netcdf, as dimensoes (longitude, latitude e tempo) e a variavel
#'
#'gfs <- carrega_modelo("/data/gfs_2019092500mod.nc");
#'
#'longitudes <- carrega_longitude(gfs);
#'
#'latitudes <- carrega_latitude(gfs);
#'
#'date <- carrega_tempo(gfsmodel)
#'
#'temperatura <- carrega_variavel(gfs, "tmp2m");
#'
#' #Plota o mapa da temperatura no tempo 1 e calcula o valor maximo na area
#'
#'temperatura_tempo1 <- temperatura[,,1];
#'
#'plota_mapa(temperatura_tempo1, vlon = longitudes, vlat = latitudes, mapa_brasil = T, mapa_amsul = T, paleta = "YlGnBu");
#'
#'media_area(temperatura_tempo1, mapa = "Brasil", vlat = latitudes, vlon = longitudes, fun = "max")
#'
#'# Plota uma serie temporal de um ponto
#'
#'coordx <- lon2x(longitudes,-46.5)
#'
#'coordy <- lat2y(latitudes,-23.5)
#'
#'temperatura_ponto <- temperatura[x = coordx, y = coordy, ]
#'
#'df_temperatura_ponto<-data.frame(date, temperatura_ponto)
#'
#'plot(df_temperatura_ponto)
#'
#'# Plota o mapa do vento
#'
#'u10m <- carrega_variavel(gfs, "ugrd10m");
#'v10m <- carrega_variavel(gfs, "vgrd10m");
#'
#'u10m_t1 <- u10m[,,1];
#'v10m_t1 <- v10m[,,1];
#'
#'plota_mapa_vento(u10m_t1,v10m_t1,vlon = longitudes, vlat = latitudes, mapa_brasil = T, mapa_amsul = T,skip = 3)
#'
#' @docType package
#' @name netcdfplot
NULL
