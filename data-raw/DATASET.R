## code to prepare `DATASET` dataset goes here

arq_gfs <- "data-raw/gfs_2019092500mod.nc"

gfsmodel <- ncdf4::nc_open(arq_gfs)                                            # Abre o arquivo do GFS

# longitudes <- ncdf4::ncvar_get(gfsmodel,"longitude") - 360                                 # Carrega as longitudes
# latitudes <- ncdf4::ncvar_get(gfsmodel,"latitude")
# tmp2m <- ncdf4::ncvar_get(gfsmodel,"tmp2m")

usethis::use_data(gfsmodel, overwrite = TRUE)

