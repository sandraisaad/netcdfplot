#' carrega_shape
#'
#' @param mapa Entrar com o nome e local do shape ou "Brasil", "America_do_Sul", "Mundo", "Pianco", "PPA", "Piracicaba"
#'
#' @return shape
#' @export shape
#'
#' @examples carrega_shape(mapa = "Brasil")
#' carrega_shape(mapa = "/storage/dados/shapes/shape_bacia_SF/bacia_sao_francisco.shp")
carrega_shape <- function(mapa=NA){
  ###############
  # Carrega na variavel global shape, um determinado mapa (formato shape)
  # Mapas disponiveis: brasil e pianco
  # Para testar em seguida faca: plot(shape)
  # Dados de entrada:
  # mapa: "brasil" ou "pianco"
  # Dependencia de bibliotecas: rgdal
  # Sandra Saad 29/04/2020
  #################

  if ( is.na(mapa) ){
    shape <<- NA

  } else {
    if (mapa=="brasil" || mapa=="Brasil") {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/brasil", layer = "brasil", verbose = F)
      shape <<- shape_brasil
    }
    else if (mapa=="America_do_Sul" || mapa=="america_do_sul" || mapa=="America_do_Sul") {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/brasil", layer = "America_do_Sul_w84", verbose = F)
      shape <<- shape_ams
    }
    else if (mapa=="Mundo" || mapa=="mundo" ) {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/mundo", layer = "paises_mundo", verbose = F)
      shape <<- shape_mundo
    }
    else if (mapa=="pianco" || mapa=="Pianco") {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/Pianco", layer = "pianco_wgs84", verbose = F)
      #shape <<- spTransform(shape,CRS("+proj=longlat +zone=24 +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
      shape <<- shape_pianco
    }
    else if (mapa=="ppa" || mapa=="PPA") {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/Pianco", layer = "bacia_PPA", verbose = F)
      shape <<- shape_ppa
    }
    else if (mapa=="Piracicaba" || mapa=="piracicaba") {
      #shape <<- readOGR(dsn = "/storage/dados/shapes/Piracicaba", layer = "bacia_Piracicaba", verbose = F)
      shape <<- shape_piracicaba
    }
    else {
      shape <<- rgdal::readOGR(dsn = mapa, verbose = F)
      shape <<- sp::spTransform(shape,sp::CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

    }
  }

}


#' matrix2raster
#'
#' Converte uma matriz para um raster em WGS85 longlat
#'
#' @param matrix Matriz de dimensão vlon X vlat
#' @param vlat Vetor de latitudes
#' @param vlon Vetor de longitudes
#'
#' @return raster
#' @export
#'
#' @examples matrix2raster(matriz,vlat,vlon)
matrix2raster <- function(matrix,vlat,vlon){
  ###############
  # Converte uma matriz em raster em WGS85 longlat
  # Entrada: matriz, vetor de latitudes e vetor de longitudes
  # Sandra Saad 22/02/2021
  #################
  r <<-raster::raster(
    t(matrix),   # sem isso, o mapa fica errado
    xmn=min(vlon), xmx=max(vlon),
    ymn=min(vlat), ymx=max(vlat),
    crs=sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  )
  if (sort(latitudes)[1]==latitudes[1]) {
    r <<- raster::flip(r, direction = 'y') # sem isso, o mapa fica invertido
  }
  return(r)
}


#' extractfromshape
#'
#'Extrai a media ou outro de um raster dentro da area de um poligono
#'
#' @param raster Raster cuja média ou outra função estatística vai ser extraída
#' @param shape Dentro do shape que vai extrair a média do raster
#' @param fun A função estatística mean, min ou max
#' @param quantil Valor entre 0 e 1 do quantil para obter dentro da área do shape
#'
#' @return Média ou função estatística ou percentil dentro da área do shape
#' @export
#'
#' @examples extractfromshape(raster,shape,fun="min")
#' extractfromshape(raster,shape,quantil=0.9)
extractfromshape <- function(raster,shape,fun="mean",quantil=NA){
  ###############
  # Extrai a media ou outro de um raster dentro da area de um poligono
  # Entrada: raster, shape e f estatisitca (mean, max, etc)
  # Sandra Saad 22/02/2021
  #################
  shp2rasterized <<- raster::rasterize(shape,raster)

  if (is.na(quantil)) {
    if (fun == "max") {
      media <- max(raster::getValues(raster::mask(raster,shp2rasterized,inverse=F)),na.rm=T)
    } else if (fun == "min") {
      media <- min(raster::getValues(raster::mask(raster,shp2rasterized,inverse=F)),na.rm=T)
    } else {
      media <- mean(raster::getValues(raster::mask(raster,shp2rasterized,inverse=F)),na.rm=T)
    }
  }
  else if (quantil > 0. & quantil < 1.0) {
    media <- quantile(raster::getValues(raster::mask(raster,shp2rasterized,inverse=F)),quantil,na.rm=T)
  }
  else{
    media <- NA
  }
  return(media)

}

#' media_area
#'
#'Extrai a media de uma matriz em um shape. Converte p/ raster primeiro
#'
#' @param matrix Matriz de dimensão vlon X vlat
#' @param mapa Definido para Brasil, America_do_Sul, Mundo, Pianco, PPA, Piracicaba
#' @param vlat Vetor de latitudes
#' @param vlon Vetor de longitudes
#' @param fun A função estatística mean, min ou max
#' @param quantil Valor entre 0 e 1 do quantil para obter dentro da área do shape
#'
#' @return A média dentro do shape
#' @export
#'
#' @examples media_area(temperatura_matriz, mapa = "Brasil", vlat = latitudes, vlon = longitudes, fun="max")
#' media_area(temperatura_matriz, mapa = "/storage/dados/shapes/shape_bacia_SF/bacia_sao_francisco.shp", vlat = latitudes, vlon = longitudes, quantil=0.9)
media_area <- function(matrix,mapa,vlat,vlon,fun="mean",quantil=NA){
  ###############
  # Extrai a media de uma matriz em um shape. Converte p/ raster primeiro
  # Sandra Saad 22/02/2021
  #################
  carrega_shape(mapa = mapa)
  r <- matrix2raster(matrix,vlat,vlon)
  media <- extractfromshape(r,shape,fun=fun,quantil=quantil)
  return(media)
}


# maskmatrix <- function(matrix,shape,vlat,vlon){
#   ###############
#   # Extrai a media de uma matriz em um shape. Converte p/ raster primeiro
#   # Sandra Saad 22/02/2021
#   #################
#
#   r <- matrix2raster(matrix,vlat,vlon)
#   media <- extractfromshape(r,shape)
#   return(media)
# }
