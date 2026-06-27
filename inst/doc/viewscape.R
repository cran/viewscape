## ----eval=FALSE---------------------------------------------------------------
# library(viewscape)

## ----eval=FALSE---------------------------------------------------------------
# #Load in DSM
# test_dsm <- terra::rast(system.file("test_dsm.tif",
#                                        package ="viewscape"))
# 
# #Load in the viewpoints
# # Load points (.shp file)
# test_viewpoints <- sf::read_sf(system.file("test_viewpoints.shp",
#                                            package = "viewscape"))
# test_viewpoint <- test_viewpoints[2,]
# 
# #Compute viewshed
# output <- viewscape::compute_viewshed(dsm = test_dsm,
#                                       viewpoints = test_viewpoint,
#                                       offset_viewpoint = 3,
#                                       r = 800,
#                                       method = 'view_tree')

## ----eval=FALSE---------------------------------------------------------------
# # overlap viewshed on DSM
# output_r <- viewscape::visualize_viewshed(output, outputtype = 'raster')
# terra::plot(test_dsm, axes=FALSE, box=FALSE, legend = FALSE)
# terra::plot(output_r, add=TRUE, col = "red", axes=FALSE, box=FALSE, legend = FALSE)
# terra::plot(test_viewpoint, add = TRUE, col = "blue", axes=FALSE, box=FALSE, legend = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# # north-facing 120° arc (−60° to 60°)
# sector <- viewscape::fov_mask(output, c(-60, 60))
# terra::plot(test_dsm, axes=FALSE, box=FALSE, legend = FALSE)
# terra::plot(viewscape::visualize_viewshed(sector, outputtype = 'raster'),
#             axes=FALSE, box=FALSE, legend = FALSE, add = TRUE, col = "red")
# terra::plot(test_viewpoint, add = TRUE, col = "blue", axes=FALSE, box=FALSE, legend = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# vm <- viewscape::visual_magnitude(output, test_dsm)

## ----eval=FALSE---------------------------------------------------------------
# terra::plot(test_dsm, axes = FALSE, box = FALSE, legend = FALSE,
#             main = "Visual magnitude over DSM", col = gray.colors(256, start = 0.1, end = 0.9))
# terra::plot(sqrt(vm), add=TRUE, alpha=0.8, axes=FALSE, box=FALSE)
# terra::plot(test_viewpoint, add = TRUE, col = "red",
#             pch = 10, axes = FALSE, box = FALSE, legend = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# vm_vals <- terra::values(vm, na.rm = TRUE)
# summary(vm_vals)
# 
# # Total visual magnitude (sums to ~1 for a full hemisphere in theory)
# sum(vm_vals)
# 
# # Identify the top 10% most visually dominant cells
# threshold <- quantile(vm_vals, 0.90)
# vm_top10 <- terra::classify(vm, cbind(0, threshold, NA))  # mask low values
# terra::plot(test_dsm, axes = FALSE, box = FALSE, legend = FALSE,
#             main = "Top 10% most visually dominant cells",
#             col = gray.colors(256, start = 0.1, end = 0.9))
# terra::plot(vm_top10, add = TRUE, col = "firebrick",
#             axes = FALSE, box = FALSE, legend = FALSE)
# terra::plot(test_viewpoint, add = TRUE, col = "blue",
#             pch = 16, axes = FALSE, box = FALSE, legend = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# # Visual magnitude within a 120° north-east arc (0° to 120°)
# sector <- viewscape::fov_mask(output, c(0, 120))
# vm_sector <- viewscape::visual_magnitude(sector, test_dsm)
# terra::plot(vm_sector, axes = FALSE, box = FALSE,
#             main = "Visual magnitude — 120° north-east arc")
# terra::plot(test_viewpoint, add = TRUE, col = "blue",
#             pch = 16, axes = FALSE, box = FALSE, legend = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# # Compute viewsheds
# output <- viewscape::compute_viewshed(dsm = test_dsm,
#                                       viewpoints = test_viewpoints,
#                                       offset_viewpoint = 10,
#                                       parallel = TRUE,
#                                       workers = 1)

## ----eval = FALSE-------------------------------------------------------------
# # Use plot all viewsheds on DSM
# par(mfrow=c(3,3))
# for(i in 1:length(output)) {
#   each <- output[[i]]
#   raster_data <- viewscape::visualize_viewshed(each, outputtype="raster")
#   terra::plot(test_dsm, axes=FALSE, box=FALSE, legend = FALSE)
#   terra::plot(raster_data, add=TRUE, col = "red", axes=FALSE, box=FALSE, legend = FALSE)
# }

## ----eval=FALSE---------------------------------------------------------------
# # Binary N x N adjacency matrix
# mat <- viewscape::intervis_network(
#   viewpoints        = test_viewpoints,
#   dsm               = test_dsm,
#   offset_viewpoint  = 10,
#   r                 = 800
# )
# mat

## ----eval=FALSE---------------------------------------------------------------
# net <- viewscape::intervis_network(
#   viewpoints        = test_viewpoints,
#   dsm               = test_dsm,
#   offset_viewpoint  = 10,
#   r                 = 800,
#   output            = "lines"
# )
# net

## ----eval=FALSE---------------------------------------------------------------
# terra::plot(test_dsm, axes = FALSE, box = FALSE, legend = FALSE,
#             main = "Intervisibility network")
# 
# # All visible links in grey
# terra::plot(net["geometry"], add = TRUE, col = "grey60", lwd = 1)
# 
# # Mutually visible links in blue
# terra::plot(net[net$mutual, "geometry"], add = TRUE, col = "#2171b5", lwd = 2)
# 
# # Viewpoints
# terra::plot(test_viewpoints, add = TRUE, col = "red", pch = 16, cex = 1.2)

## ----eval=FALSE---------------------------------------------------------------
# n_vp <- nrow(sf::st_coordinates(test_viewpoints))
# # cycle through a set of representative heights, one per viewpoint
# heights <- rep(c(1.7, 6, 12), length.out = n_vp)
# 
# mat_heights <- viewscape::intervis_network(
#   viewpoints       = test_viewpoints,
#   dsm              = test_dsm,
#   offset_viewpoint = heights,
#   r                = 1600
# )
# mat_heights

## ----eval=FALSE---------------------------------------------------------------
# #Load in DSM
# test_dsm <- terra::rast(system.file("test_dsm.tif",
#                                        package ="viewscape"))
# # Load DTM
# test_dtm <- terra::rast(system.file("test_dtm.tif",
#                                        package ="viewscape"))
# 
# # Load canopy raster
# test_canopy <- terra::rast(system.file("test_canopy.tif",
#                                        package ="viewscape"))
# 
# # Load building footprints raster
# test_building <- terra::rast(system.file("test_building.tif",
#                                        package ="viewscape"))
# 

## ----eval=FALSE---------------------------------------------------------------
# # calculate metrics given the viewshed, canopy, and building footprints
# test_metrics <- viewscape::calculate_viewmetrics(output[[1]],
#                                                  test_dsm,
#                                                  test_dtm,
#                                                  list(test_canopy, test_building))
# test_metrics

## ----eval=FALSE---------------------------------------------------------------
# # load landuse raster
# test_landuse <- terra::rast(system.file("test_landuse.tif",
#                                         package ="viewscape"))

## ----eval=FALSE---------------------------------------------------------------
# # the Shannon Diversity Index (SDI)
# test_diversity <- viewscape::calculate_diversity(output[[1]],
#                                                  test_landuse,
#                                                  proportion = TRUE)
# # SDI and The proportion of each type of land use
# test_diversity

## ----eval=FALSE---------------------------------------------------------------
# # calculate the percentage of canopy coverage
# test_canopy_proportion <- viewscape::calculate_feature(viewshed = output[[1]],
#                                                        feature = test_canopy,
#                                                        type = 2,
#                                                        exclude_value=0)
# test_canopy_proportion

## ----eval=FALSE---------------------------------------------------------------
# # Requires the greenSD package:
# # devtools::install_github("billbillbilly/greenSD")
# 
# # Default: equirectangular + ESRI WorldImagery → 3-band RGB panorama
# pano_rgb <- viewscape::pano_view(
#   dsm   = test_dsm,
#   vpt   = test_viewpoint,
#   h     = 3,              # observer height above ground (m)
#   plot  = TRUE
# )
# # pano_rgb is a 3-band SpatRaster (R, G, B, 0–255)
# # Use plotRGB() to display it at any time:
# terra::plotRGB(pano_rgb, r = 1, g = 2, b = 3)

## ----eval=FALSE---------------------------------------------------------------
# pano_custom <- viewscape::pano_view(
#   dsm       = test_dsm,
#   vpt       = test_viewpoint,
#   h         = 6,
#   pano_dim  = c(512, 1024),        # taller panorama for more vertical detail
#   sky_color = c(200, 220, 255),    # pale-blue sky
#   heading   = 90,                  # face east
#   plot      = TRUE
# )

## ----eval=FALSE---------------------------------------------------------------
# test_landuse <- terra::rast(system.file("test_landuse.tif", package = "viewscape"))
# 
# pano_lc <- viewscape::pano_view(
#   dsm      = test_dsm,
#   vpt      = test_viewpoint,
#   h        = 5,
#   semantic = test_landuse,   # land-use raster with class codes
#   plot     = TRUE            # plots depth (left) and land-use codes (right)
# )
# 
# # Access individual layers
# depth_pano <- pano_lc[["equirectangular_depth"]]
# lc_pano    <- pano_lc[["equirectangular_semantic"]]
# terra::plot(lc_pano, main = "Land use codes in panoramic view")

## ----eval=FALSE---------------------------------------------------------------
# test_building <- terra::rast(system.file("test_building.tif", package = "viewscape"))
# 
# pano_bld <- viewscape::pano_view(
#   dsm      = test_dsm,
#   vpt      = test_viewpoint,
#   h        = 6,
#   semantic = test_building,   # binary building-footprint mask
#   plot     = TRUE
# )

## ----eval=FALSE---------------------------------------------------------------
# test_building <- terra::rast(system.file("test_building.tif", package = "viewscape"))
# 
# pano_bld <- viewscape::pano_view(
#   dsm      = test_dsm,
#   vpt      = test_viewpoint,
#   h        = 6,
#   semantic = test_canopy,   # binary tree canopy mask
#   plot     = TRUE
# )

