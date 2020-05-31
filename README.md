
<!-- README.md is generated from README.Rmd. Please edit that file -->

# osgridref

# Overview

Spatial data is often store as [Ordinance Survey National
Grid](https://en.wikipedia.org/wiki/Ordnance_Survey_National_Grid)
references. This is an easy way to recorded spatial data in the field
but isn’t straight forward to convert to coordinates. The goalof the
`osgridref` package is to provide a functions to easily convert grid
references to eastings and northings (EPSG:27700) and back again.

# Installation

The package can currently be installed from github:

``` r
# Or the the development version from GitHub:
# install.packages("devtools")
# devtools::install_github("matthewjwhittle/osgridref")
```

``` r
library(osgridref)
```

# Examples

``` r
grid_refs <- c("TA 304 403", "SE 2344 0533", "SE13")
gridref_to_xy(grid_refs)
```

    ## # A tibble: 3 x 3
    ##        x      y resolution
    ##    <dbl>  <dbl>      <dbl>
    ## 1 530400 440300        100
    ## 2 423440 405330         10
    ## 3 410000 430000      10000
