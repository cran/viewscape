# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

get_depths <- function(px, py, x, y, num) {
    .Call('_viewscape_get_depths', PACKAGE = 'viewscape', px, py, x, y, num)
}

visibleLabel <- function(viewpoint, dsm, h, max_dis) {
    .Call('_viewscape_visibleLabel', PACKAGE = 'viewscape', viewpoint, dsm, h, max_dis)
}

