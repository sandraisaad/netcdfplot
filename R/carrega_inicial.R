

#' carrega o modelo (o arquivo em Netcdf)
#'
#' Abre o arquivo com a funcao nc_open do ncdf4
#'
#' @param arquivo Nome (e caminho) do arquivo em netcdf
#'
#' @return O modelo carregado
#' @export
#'
#' @examples gfs <- carrega_modelo("/data/gfs_2019092500mod.nc")
carrega_modelo <- function(arquivo){
  modelo <- ncdf4::nc_open(arquivo)
  return(modelo)
}

#' Carrega o vetor de longitudes
#'
#' Converte 0 a 360 em -180 a 180
#'
#' @param modelo O Netcdf já carregado com a funcao (carrega_modelo)
#' @param nome_longitude longitude, lon, LONGITUDE
#'
#' @return o vetor de longitude carregado
#' @export
#'
#' @examples longitudes <- carrega_longitude(gfs,nome_longitude="lon")
#'           longitudes <- carrega_longitude(gfs)
carrega_longitude <- function(modelo,nome_longitude="longitude"){
  lon <- ncdf4::ncvar_get(modelo,nome_longitude)
  lon[lon>180]<-lon[lon>180]-360  # Converte de 180 a 360 em -180 a 0
  return(lon)
}

#' Carrega o vetor de latitudes
#'
#' @param modelo O Netcdf já carregado com a funcao (carrega_modelo)
#' @param nome_latitude latitude, lat, latitude
#'
#' @return o vetor de latitude carregado
#' @export
#'
#' @examples latitudes <- carrega_latitude(gfs,nome_latitude="lat")
#'           latitudes <- carrega_latitude(gfs)
carrega_latitude <- function(modelo,nome_latitude="latitude"){
  lat <- ncdf4::ncvar_get(modelo,nome_latitude)
  return(lat)
}

#' Carrega o dado da variavel de um netcdf
#'
#' @param modelo O Netcdf já carregado com a funcao (carrega_modelo)
#' @param nome_variavel Nome da variavel
#'
#' @return O array da variavel (temperatura, precipitacao, etc)
#' @export
#'
#' @examples temperatura <- carrega_variavel(gfs,"tmp2m")
carrega_variavel <- function(modelo,nome_variavel){
  variavel <- ncdf4::ncvar_get(modelo,nome_variavel)
  return(variavel)
}

