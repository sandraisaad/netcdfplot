#' netcdfplot
#'
#' Ferramentas para plotar e analisar dados em Netcdf
#'
#' Sandra I. Saad
#' sandraisaad@@gmail.com
#'
#' @section Exemplos:
#' gfs <- carrega_modelo("/data/gfs_2019092500mod.nc")
#' longitudes <- carrega_longitude(gfs)
#' latitudes <- carrega_latitude(gfs)
#' temperatura <- carrega_variavel(gfs,"tmp2m")
#' temperatura_tempo1 <-temperatura[,,1]
#' plota_mapa(temperatura_tempo1, vlon = longitudes, vlat = latitudes, mapa_brasil= T, mapa_amsul = T, paleta = "YlGnBu")
#' media_area(temperatura_tempo1, mapa = "Brasil",vlat = latitudes, vlon = longitudes,fun = "max")
#'
#' @docType package
#' @name netcdfplot
NULL
