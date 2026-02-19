#' Load date/time vector 
#'
#' Returns the date/time vector from a NetCDF file in POSIXct format
#'
#' @param nc The loaded netcdfile file (using the function carrega_modelo)
#' @param  time  Name of the time variable in the NetCDF file. Use
#' \code{"time"} (default) or \code{"valid_time"}.
#'
#' @return A date/time vector in POSIXct format
#' @export
#'
#' @examples carrega_tempo(gfs)
#' carrega_tempo(era5,time="valid_time")

carrega_tempo <- function(nc,time="time"){
  tempo_unidade <- ncdf4::ncatt_get(nc,time,"units")$value
  tempo0 <- strsplit(tempo_unidade," ")[[1]][3]
  unidade <- strsplit(tempo_unidade," ")[[1]][1]
  if (length(strsplit(tempo_unidade, " ")[[1]]) == 4) {
    hora0 <- as.integer(substr(as.character(strsplit(tempo_unidade," ")[[1]][4]),1,2))
  }
  else {
    hora0 <- 0
  }
  if (time == "time") {
    tempo <- nc$dim$time$vals + hora0
  } else if (time == "valid_time") {
    tempo <- nc$dim$valid_time$vals + hora0
  }
  # tempof <- ncdf.tools::convertDateNcdf2R(tempo, units = unidade, origin = as.POSIXct(tempo0, tz = "UTC"),
  #                                      time.format = c("%Y-%m-%d", "%Y-%m-%d %H:%M:%S","%Y-%m-%d %H:%M", "%Y-%m-%d %Z %H:%M", "%Y-%m-%d %Z %H:%M:%S"))
  # Reescrito pelo trecho abaixo em 31/02/206 devido a depreciacao da biblioteca ncdf.tools
  if (grepl("hours", unidade)) {
    tempof <- as.POSIXct(tempo*3600,origin=tempo0, tz="UTC") #+ tempo
    } else if (grepl("seconds", unidade)) {
      tempof <- as.POSIXct(tempo,origin=tempo0, tz = "UTC")
    } else if (grepl("days", unidade)) {
      tempof <- as.POSIXct(tempo* 86400, tz="UTC") #+ tempo
    } else {
      print("[E] Unidade nao definida.")
      print(unidade)
      return()
    }
  return(tempof)
}

#' Converts a given Longitude to an x index 
#'
#' Converts a longitude value to its corresponding x index (from 1 to the length of the longitude vector).
#'
#' @param vetor_lon Longitude vector
#' @param loni Longitude value to be converted to an x index
#'
#' @return The index of the longitude in \code{vetor_lon} that is
#' closest to the requested value.
#' @export
#'
#' @examples lon2x(longitudes,-46.5)
lon2x <- function(vetor_lon,loni){
  if (loni < 0 & min(vetor_lon > 0)) {   # Soma 360 nas longitude caso necessario
    loni <- loni + 360
  }
  if ( (loni >= min(vetor_lon)) & (loni <= max(vetor_lon)) ){
    x <- which.min(abs(vetor_lon - loni))[1]
  } else {
    if (min(vetor_lon) > 0) {
      print(paste("[W] Longitude fora do dominio. Escolha entre ",min(vetor_lon)," e ", max(vetor_lon),
                  " ou entre ", min(vetor_lon)-360," e ", max(vetor_lon)-360))
    } else {
      print(paste("[W] Longitude fora do dominio. Escolha entre ",min(vetor_lon)," e ", max(vetor_lon)))
    }
    x <- -999.9

  }
  return(x)
}

#' Converts a given Latitude to an y index 
#'
#' Converts a latitude value to its corresponding y index (from 1 to the length of the latitude vector).
#'
#' @param vetor_lat Latitude vector
#' @param lati Latitude value to be converted to an y index
#'
#' @return The index of the latitude in \code{vetor_lat} that is
#' closest to the requested value.
#' @export
#'
#' @examples lat2y(latitudes,-23.5)
lat2y <- function(vetor_lat,lati){
  # Converte a latitude em coordenada y
  # vetor_lat eh o vetor da latitude
  # lati eh a latgitude de um ponto a ser convertida
  if ( (lati >= min(vetor_lat)) & (lati <= max(vetor_lat)) ){
    y <- which.min(abs(vetor_lat - lati))[1]
  }else{
    print(paste("[W] Latitude ",lati," fora do dominio. Escolha entre ",min(vetor_lat)," e ", max(vetor_lat)))
    y <- -999.9
  }
  return(y)
}

#' Shows the names of the variables available in the Netcdf file
#'
#' @param nc The loaded netcdfile file (using the function carrega_modelo)
#'
#' @return the names of the variables available in the Netcdf file
#' @export
#'
#' @examples shownames(gfs)
shownames <- function(nc){
  # Mostre o nome das variaveis do arquivo
  # entrar com o arquivo nc
  names(nc[['var']])
}

#' Provides details about the requested variable in the netcdf file
#'
#' Provides details about units and others
#'
#' @param nc The loaded netcdfile file (using the function carrega_modelo)
#' @param var Variable name
#'
#' @return Details about the requested variable
#' @export
#'
#' @examples explainname(gfs,"precipitation")
#'           explainname(gfs,"tmp2m")
explainname <- function(nc,var){
  variavel_completa <- ncdf4::ncatt_get(nc,var,"long_name")$value
  return(variavel_completa)
}



