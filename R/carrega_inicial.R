

#' Load the netcdf file
#'
#' Abre o arquivo com a funcao nc_open do ncdf4
#'
#' @param arquivo Nome (e caminho) do arquivo em netcdf
#'
#' @return The loaded netecdf file
#'
#' @export
#'
#' @examples 
#' arq <- netcdfplot::gfs_example_file()
#' modelo <- netcdfplot::carrega_modelo(arq)
carrega_modelo <- function(arquivo){
  modelo <- ncdf4::nc_open(arquivo)
  return(modelo)
}

#' Load the longitude vector
#'
#' Converts from 0-360 to -180 to 180 degrees
#'
#' @param modelo The loaded netcdfile file (using the function carrega_modelo)
#' @param nome_longitude The longitude name as it is in the Netcdf file (e.g. longitude, lon, LONGITUDE)
#'
#' @return Returns the longitude vector
#'
#' @export
#'
#' @examples 
#' if (interactive()) {
#' longitudes <- carrega_longitude(modelo,nome_longitude="lon")
#'           longitudes <- carrega_longitude(modelo)
#' }
carrega_longitude <- function(modelo,nome_longitude="longitude"){
  lon <- ncdf4::ncvar_get(modelo,nome_longitude)
  lon[lon>180]<-lon[lon>180]-360  # Converte de 180 a 360 em -180 a 0
  return(lon)
}

#' Load the latitude vector
#'
#' @param modelo The loaded netcdfile file (using the function carrega_modelo)
#' @param nome_latitude  The latitude name as it is in the Netcdf file (e.g. latitude, lat, LATITUDE)
#'
#' @return Returns the latitude vector
#'
#' @export
#'
#' @examples 
#' if (interactive()) {
#' latitudes <- carrega_latitude(modelo,nome_latitude="lat")
#'           latitudes <- carrega_latitude(modelo)
#' }
carrega_latitude <- function(modelo,nome_latitude="latitude"){
  lat <- ncdf4::ncvar_get(modelo,nome_latitude)
  return(lat)
}

#' Load the variable data (e.g. temperature, precipitation) of a netcdf file
#'
#' @param modelo The loaded netcdfile file (using the function carrega_modelo)
#' @param nome_variavel Name of the variable (use shownames() function to find it)
#'
#' @return THe variable array
#' @export
#'
#' @examples
#' if (interactive()) {
#' temperatura <- carrega_variavel(modelo,"tmp2m")
#' }
carrega_variavel <- function(modelo,nome_variavel){
  variavel <- ncdf4::ncvar_get(modelo,nome_variavel)
  return(variavel)
}

