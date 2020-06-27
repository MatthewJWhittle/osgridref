require(dplyr)
x <-
  c("SE123320", "TA203523", "102302")

expect_warning(gridref_to_xy(x))

expected_result <- tibble(x = c(412300, 520300, NA),
                          y = c(432000, 452300, NA),
                          resolution = c(100, 100, NA))

expect_equal(gridref_to_xy(x), expected_result)
