#' Caminho para o NetCDF de exemplo
#'
#' @return Caminho completo para o arquivo .nc
#' @export


gfs_example_file <- function() {
  system.file(
    "extdata",
    "gfs_sample.nc",
    package = "netcdfplot"
  )
}
