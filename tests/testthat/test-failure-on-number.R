
# Numeric vector should throw an error
x <- as.numeric(140)

expect_error(gridref_to_xy(x))
