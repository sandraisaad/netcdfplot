#' Plot a map
#'
#' @param array_var2d Matriz (em 2 dimensões) com o campo a ser plotado
#' @param titulo Título do mapa (opcional)
#' @param legenda Nome em cima da legenda (opcional)
#' @param vlon Vetor com as longitudes correspondente a array_var2d
#' @param vlat Vetor com as latitudes
#' @param loni Longitude inicial para o corte do mapa (opcional)
#' @param lonf           final
#' @param lati Latitude  inicial
#' @param latf Latitude  final
#' @param mapa Mapa a ser mostrado
#' @param paleta Paleta de cores a ser utilizada. Default: "RdBu".Ver outras em http://www.sthda.com/english/wiki/colors-in-r
#' @param paleta_rev Se T, inverte a paleta de cores
#' @param mapa_brasil Se T, acrescenta o mapa do Brasil e os estados
#' @param mapa_amsul Se T, acrescenta o mapa da América do Sul
#' @param mapa_mundo Se T, acrescenta o mapa dos países do mundo
#' @param intervalos Um vetor com os intervalo de dados a ser considerado. Vale se legenda_intervalos=T
#' @param interpolate Se F, mostra pixelado e não interpolado
#' @param legenda_intervalos Se T, mostra a legenda em intervalos
#' @param contorno Se T, mostra os contornos do plot
#'
#' @return
#' @export
#'
#' @examples
#'
#' plota_mapa(prec,titulo = expression(paste("Precipitation (mm yr"^"-1",")")),legenda="Precipitação (mm)", vlon=longitudes,vlat=latitudes,loni=-39,lonf=-36,lati=-7.78,latf=-5, mapa = "PPA", mapa_brasil = T,mapa_amsul = T, paleta_rev = F, paleta = "YlGnBu", legenda_intervalos = F,contorno = F)
#'
#' plota_mapa(temperatura,vlon=longitudes,vlat=latitudes)
#'
plota_mapa <- function(array_var2d,titulo="",legenda="",vlon,vlat,loni=NA,lonf=NA,lati=NA,latf=NA,mapa=NA,paleta="RdBu",paleta_rev=F,
                       mapa_brasil=F,mapa_amsul=F,mapa_mundo=F,intervalos=NA, interpolate=T,legenda_intervalos=F,contorno=F){

  if ( is.na(lati) | is.na(latf) | is.na(loni) | is.na(lonf) ){
    xi <- 1
    xf <- length(vlon)
    yi <- 1
    yf <- length(vlat)
  } else {
    xi <- lon2x(vlon,loni)
    xf <- lon2x(vlon,lonf)
    yi <- lat2y(vlat,lati)
    yf <- lat2y(vlat,latf)
  }

  v_var2d <- as.vector(array_var2d[xi:xf,yi:yf])                              # Transforma a matriz em vetor

  lonlat <- expand.grid(vlon[xi:xf], vlat[yi:yf]); names(lonlat) <- c("lon", "lat")   # Gera um vetor com 2 colunas: lon e lat
  df_space <- data.frame(cbind(lonlat, v_var2d))                  # Gera um dataframe com 3 colunas: lon, lat, temperatura

  carrega_shape(mapa = mapa)

  if (isTRUE(paleta_rev)) {
    colours = rev(RColorBrewer::brewer.pal(10, paleta))
  } else{
    colours = RColorBrewer::brewer.pal(10, paleta)
  }

  plt <- ggplot2::ggplot(df_space, ggplot2::aes(lon,lat)) + ggplot2::geom_raster(ggplot2::aes(fill = v_var2d),interpolate = interpolate,low=colours[1],high=colours[10]) +  # Plota o mapa
    ggplot2::ggtitle(titulo)         +          # Acrescenta o titulo
    ggplot2::theme(text = ggplot2::element_text(size = 18), axis.title = ggplot2::element_blank())

  if (isTRUE(contorno)) {
    plt <- plt + ggplot2::geom_contour(ggplot2::aes(z = v_var2d), col ="Black") # Acrecenta a saida em contorno
  }
  
  if(isTRUE(legenda_intervalos)){
    plt <- plt +  ggplot2::guides(fill=ggplot2::guide_legend(title=legenda))
  } else {
    plt <- plt +  ggplot2::guides() + ggplot2::theme(legend.title = ggplot2::element_blank())
  }

  if (!is.na(intervalos) ) {
    plt <- plt +  ggplot2::scale_fill_gradientn(colours = colours, breaks = intervalos, limit=c(min(intervalos),max(intervalos)),oob=scales::squish )           # Define as cores
  } else {
    plt <- plt +  ggplot2::scale_fill_gradientn(colours = colours)
  }

  if ( !is.na(lati) & !is.na(latf) & !is.na(loni) & !is.na(lonf) ){
    #plt <- plt + scale_y_continuous(limits = c(lati, latf))
    plt <- plt + ggplot2::coord_equal(ylim = c(vlat[yi], vlat[yf]),xlim = c(vlon[xi], vlon[xf]))
  }

  if (!is.na(mapa) ) {
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black")
  }
  if (isTRUE(mapa_brasil)) {
    carrega_shape(mapa = "Brasil")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  if (isTRUE(mapa_amsul)) {
    carrega_shape(mapa = "America_do_Sul")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  if (isTRUE(mapa_mundo)) {
    carrega_shape(mapa = "Mundo")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  plt
}


#' Save image
#'
#' Plot image and save in jpg and svg (if chosen)
#'
#' @param plt A figura plotada no R
#' @param file_name Nome da Figura sem extensão
#' @param width Largura a ser salva
#' @param height Altura a ser salva
#' @param salva_svg Se T salva em svg também
#'
#' @return
#' @export
#'
#' @examples salva_figura(plt,"figura_temperatura",width=2500,height=2000,salva_svg=F)
salva_figura<-function(plt,file_name, width=2500,height=2000,salva_svg=F){
  #salva_figura<-function(plt,file_name, width=600,height=500){
  print(plt)
  filename <-  paste(file_name,".jpg",sep = "")
  jpeg(filename = filename,width = width,height = height, res =300)
  print(plt)
  dev.off()
  print(paste("[I] Salvo ",filename,".jpg",sep=""))

  if(isTRUE(salva_svg)){
    print(plt)
    filenamesvg <-  paste(file_name,".svg",sep = "")
    ggplot2::ggsave(filenamesvg,width = 6, height = 5)
    print(paste("[I] Salvo ",filename,".svg",sep=""))
  }


}


#' Plots wind vectorial field 
#'
#' @param array_u2d Matriz da componente zonal do vento, u, em 2 dimensões
#' @param array_v2d Matriz da componente meridional do vento, v, em 2 dimensões
#' @param titulo Título do mapa (opcional)
#' @param legenda Nome em cima da legenda (opcional)
#' @param vlon Vetor com as longitudes correspondente a array_var2d
#' @param vlat Vetor com as latitudes
#' @param loni Longitude inicial para o corte do mapa (opcional)
#' @param lonf           final
#' @param lati Latitude  inicial
#' @param latf Latitude  final
#' @param mapa Mapa a ser mostrado
#' @param mapa_brasil Se T, acrescenta o mapa do Brasil e os estados
#' @param mapa_amsul Se T, acrescenta o mapa da América do Sul
#' @param mapa_mundo Se T, acrescenta o mapa dos países do mundo
#' @param intervalos Um vetor com os intervalo de dados a ser considerado. Vale se legenda_intervalos=T
#' @param legenda_intervalos Se T, mostra a legenda em intervalos
#' @param skip Pula alguns pontos de grades para nao ficar poluido. Padrao 3
#'
#' @return
#' @export
#'
#' @examples
#'
#' plota_mapa_vento(u10m_t1,v10m_t1,vlon = longitudes, vlat = latitudes)
#'


plota_mapa_vento <- function(array_u2d,array_v2d,titulo="",legenda="",vlon,vlat,loni=NA,lonf=NA,lati=NA,latf=NA,mapa=NA,
                                   #paleta="RdBu",paleta_rev=F,interpolate=T,
                                   mapa_brasil=F,mapa_amsul=F,mapa_mundo=F,intervalos=NA, legenda_intervalos=F,
                                   skip=3){
  library(grid) 
  if ( is.na(lati) | is.na(latf) | is.na(loni) | is.na(lonf) ){
    xi <- 1
    xf <- length(vlon)
    yi <- 1
    yf <- length(vlat)
  } else {
    xi <- lon2x(vlon,loni)
    xf <- lon2x(vlon,lonf)
    yi <- lat2y(vlat,lati)
    yf <- lat2y(vlat,latf)
  }
  
  u2d <- as.vector(array_u2d[xi:xf,yi:yf])                              # Transforma a matriz em vetor
  v2d <- as.vector(array_v2d[xi:xf,yi:yf])                              # Transforma a matriz em vetor

  lonlat <- expand.grid(vlon[xi:xf], vlat[yi:yf]); names(lonlat) <- c("lon", "lat")   # Gera um vetor com 2 colunas: lon e lat
  df_space <- data.frame(cbind(lonlat, u2d,v2d))                  # Gera um dataframe com 3 colunas: lon, lat, temperatura

  df_space$vento_int <- sqrt(df_space$u2d^2 + df_space$v2d^2)
  
  carrega_shape(mapa = mapa)

  # if (isTRUE(paleta_rev)) {
  #   colours = rev(RColorBrewer::brewer.pal(9, paleta))
  # } else{
  #   colours = RColorBrewer::brewer.pal(9, paleta)
  # }

  plt <- ggplot2::ggplot(df_space, ggplot2::aes(lon,lat)) + 

    metR::geom_arrow(ggplot2::aes(dx = u2d, dy = v2d, colour = vento_int), skip = skip) +
    ggplot2::scale_colour_viridis_c(option = "turbo") +
    metR::scale_mag() +
  
    ggplot2::ggtitle(titulo)         +          # Acrescenta o titulo
    ggplot2::theme(text = ggplot2::element_text(size = 18), axis.title = ggplot2::element_blank())
  
  if(isTRUE(legenda_intervalos)){
    plt <- plt +  ggplot2::guides(fill=ggplot2::guide_legend(title=legenda))
  } else {
    plt <- plt +  ggplot2::guides() + ggplot2::theme(legend.title = ggplot2::element_blank())
  }

  if (!is.na(intervalos) ) {
    plt <- plt +  ggplot2::scale_fill_gradientn(colours = colours, breaks = intervalos, limit=c(min(intervalos),max(intervalos)),oob=scales::squish )           # Define as cores
  } else {
    plt <- plt +  ggplot2::scale_fill_gradientn(colours = colours)
  }

  if ( !is.na(lati) & !is.na(latf) & !is.na(loni) & !is.na(lonf) ){
    #plt <- plt + scale_y_continuous(limits = c(lati, latf))
    plt <- plt + ggplot2::coord_equal(ylim = c(vlat[yi], vlat[yf]),xlim = c(vlon[xi], vlon[xf]))
  }

  if (!is.na(mapa) ) {
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black")
  }
  if (isTRUE(mapa_brasil)) {
    carrega_shape(mapa = "Brasil")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  if (isTRUE(mapa_amsul)) {
    carrega_shape(mapa = "America_do_Sul")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  if (isTRUE(mapa_mundo)) {
    carrega_shape(mapa = "Mundo")
    plt <- plt + ggplot2::geom_polygon(data = shape, ggplot2::aes(group = group, x = long, y = lat), fill=NA, color="black",size=0.1)
  }
  plt
}




