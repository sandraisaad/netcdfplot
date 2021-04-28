#' carrega_tempo
#'
#' Entrar com o netcdf já carregado
#'
#' @param nc Arquivo carregado em netcdf
#'
#' @return Esta função carrega o tempo de um arquivo Netcdf no formato adequado
#' @export
#'
#' @examples carrega_tempo(gfs)
carrega_tempo <- function(nc){
  tempo_unidade <- ncdf4::ncatt_get(nc,"time","units")$value
  tempo0 <- strsplit(tempo_unidade," ")[[1]][3]
  unidade_tempo <- strsplit(tempo_unidade," ")[[1]][1]
  hora0 <- as.integer(substr(as.character(strsplit(tempo_unidade," ")[[1]][4]),1,2))
  tempo <- nc$dim$time$vals+hora0
  tempof <- ncdf.tools::convertDateNcdf2R(tempo, units = unidade_tempo, origin = as.POSIXct(tempo0, tz = "UTC"),
                              time.format = c("%Y-%m-%d", "%Y-%m-%d %H:%M:%S","%Y-%m-%d %H:%M", "%Y-%m-%d %Z %H:%M", "%Y-%m-%d %Z %H:%M:%S"))
  return(tempof)
}

#' lon2x
#'
#' Converte a longitude em coordenada x
#'
#' @param vetor_lon Vetor com as longitudes
#' @param loni Longitude a set convertida para x
#'
#' @return posição do vetor com a longitude mais próxima da solicitada
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

#' lat2y
#'
#' Converte a latitude em coordenada y
#'
#' @param vetor_lat Vetor com as latitude
#' @param lati Latitude a set convertida para y
#'
#' @return posição do vetor com a latitude mais próxima da solicitada
#' @export
#'
#' @examples lat2y(latitudes,-23.5)
lat2y <- function(vetor_lat,lati){
  # Converte a latitude em coordenada y
  # vetor_lat eh o vetor da latgitude
  # lati eh a latgitude de um ponto a ser convertida
  if ( (lati >= min(vetor_lat)) & (lati <= max(vetor_lat)) ){
    y <- which.min(abs(vetor_lat - lati))[1]
  }else{
    print(paste("[W] Latitude ",lati," fora do dominio. Escolha entre ",min(vetor_lat)," e ", max(vetor_lat)))
    y <- -999.9
  }
  return(y)
}

#' shownames
#'
#' @param nc Arquivo carregado em netcdf
#'
#' @return nome das variaveis do arquivo
#' @export
#'
#' @examples shownames(gfs)
shownames <- function(nc){
  # Mostre o nome das variaveis do arquivo
  # entrar com o arquivo nc
  names(nc[['var']])
}

#' explainname
#'
#' Fornece detalhes sobre a variável do Netcdf
#'
#' @param nc Arquivo carregado em netcdf
#' @param var Nome da variável
#'
#' @return Detalhes sobre a variável
#' @export
#'
#' @examples explainname(gfs,"precipitation")
#'           explainname(gfs,"tmp2m")
explainname <- function(nc,var){
  variavel_completa <- ncdf4::ncatt_get(nc,var,"long_name")$value
  return(variavel_completa)
}



