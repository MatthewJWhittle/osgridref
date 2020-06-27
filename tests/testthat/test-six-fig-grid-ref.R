require(dplyr)


x <- c("SE 123 356")
result <- gridref_to_xy(x)

expected_result <- tibble(x = 412300, y = 435600, resolution = 100)

expect_equal(result, expected_result)
