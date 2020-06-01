df <- data.frame(c1 = c(0, 2, 4),
                 c2 = c("a", "b", "c"))

expect_error(gridref_to_xy(df))
