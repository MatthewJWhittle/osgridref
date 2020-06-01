require(testthat)
require(dplyr)
require(osgridref)

x <- c("SE12233355")
result <- gridref_to_xy(x)

expected_result <- tibble(x = 412230, y = 433550, resolution = 10)

expect_equal(result, expected_result)
