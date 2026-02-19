#' Find the NetCDF file provided for testing
#'
#' @return The full path to the example .nc file.
#' @export
#' @examples
#' arq <- gfs_example_file()

gfs_example_file <- function() {
  system.file(
    "extdata",
    "gfs_sample.nc",
    package = "netcdfplot"
  )
}
