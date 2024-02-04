## -----------------------------------------------------------------------------
library(viewscape)

## -----------------------------------------------------------------------------
#Load in DSM
test_dsm <- terra::rast(system.file("test_dsm.tif", 
                                       package ="viewscape"))

#Load in the viewpoint
test_viewpoint <- sf::read_sf(system.file("test_viewpoint.shp", 
                                          package = "viewscape"))

#Compute viewshed
output <- viewscape::compute_viewshed(dsm = test_dsm, 
                                      viewpoints = test_viewpoint, 
                                      offset_viewpoint = 6)

## ----eval=FALSE---------------------------------------------------------------
#  # overlap viewshed on DSM
#  output_r <- viewscape::visualize_viewshed(output, outputtype = 'raster')
#  terra::plot(test_dsm, axes=FALSE, box=FALSE, legend = FALSE)
#  terra::plot(output_r, add=TRUE, col = "red", axes=FALSE, box=FALSE, legend = FALSE)
#  terra::plot(test_viewpoint, add = TRUE, col = "blue", axes=FALSE, box=FALSE, legend = FALSE)

## -----------------------------------------------------------------------------
#Load in DSM
test_dsm <- terra::rast(system.file("test_dsm.tif", 
                                       package ="viewscape"))

# Load points (.shp file)
test_viewpoints <- sf::read_sf(system.file("test_viewpoints.shp", 
                                           package = "viewscape"))

# Compute viewsheds
output <- viewscape::compute_viewshed(dsm = test_dsm, 
                                      viewpoints = test_viewpoints, 
                                      offset_viewpoint = 6, 
                                      parallel = TRUE, 
                                      workers = 1)

## ----eval = FALSE-------------------------------------------------------------
#  # Use plot all viewsheds on DSM
#  par(mfrow=c(3,3))
#  for(i in 1:length(output)) {
#    each <- output[[i]]
#    raster_data <- viewscape::visualize_viewshed(each, outputtype="raster")
#    terra::plot(test_dsm, axes=FALSE, box=FALSE, legend = FALSE)
#    terra::plot(raster_data, add=TRUE, col = "red", axes=FALSE, box=FALSE, legend = FALSE)
#  }

## -----------------------------------------------------------------------------
#Load in DSM
test_dsm <- terra::rast(system.file("test_dsm.tif", 
                                       package ="viewscape"))
# Load DTM
test_dtm <- terra::rast(system.file("test_dtm.tif", 
                                       package ="viewscape"))

# Load canopy raster
test_canopy <- terra::rast(system.file("test_canopy.tif", 
                                       package ="viewscape"))

# Load building footprints raster
test_building <- terra::rast(system.file("test_building.tif", 
                                       package ="viewscape"))


## -----------------------------------------------------------------------------
# calculate metrics given the viewshed, canopy, and building footprints
test_metrics <- viewscape::calculate_viewmetrics(output[[1]], 
                                                 test_dsm, 
                                                 test_dtm, 
                                                 list(test_canopy, test_building))
test_metrics

## -----------------------------------------------------------------------------
# load landuse raster
test_landuse <- terra::rast(system.file("test_landuse.tif",
                                        package ="viewscape"))

## -----------------------------------------------------------------------------
# the Shannon Diversity Index (SDI)
test_diversity <- viewscape::calculate_diversity(output[[1]], 
                                                 test_landuse,
                                                 proportion = TRUE)
# SDI and The proportion of each type of land use
test_diversity

## -----------------------------------------------------------------------------
# load canopy raster
test_canopy <- terra::rast(system.file("test_canopy.tif",
                                          package ="viewscape"))
# calculate the percentage of canopy coverage  
test_canopy_proportion <- viewscape::calculate_feature(viewshed = output[[1]],
                                                       feature = test_canopy,
                                                       type = 2, 
                                                       exclude_value=0)
test_canopy_proportion

