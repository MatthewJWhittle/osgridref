#' OS GB Look up table
#'
#' This function creates a lookup table of os grid square letters and numbers
#' @keywords osgb grid reference look up
#' @return A \code{data.frame} with 3 columns, the letters identifying each square and their x and y min coordinates
osgb_lookup <- function() {

  letter1 <- list(
    "S" = c(0, 0),
    "T" = c(5, 0),
    "N" = c(0, 5),
    "H" = c(0, 10),
    "O" = c(5, 5)
  )
  letter1 <- do.call(rbind, letter1)


  letter2 <- list(
    "A" = c(y = 4, x = 0),
    "B" = c(4, 1),
    "C" = c(4, 2),
    "D" = c(4, 3),
    "E" = c(4, 4),
    "F" = c(3, 0),
    "G" = c(3, 1),
    "H" = c(3, 2),
    "J" = c(3, 3),
    "K" = c(3, 4),
    "L" = c(2, 0),
    "M" = c(2, 1),
    "N" = c(2, 2),
    "O" = c(2, 3),
    "P" = c(2, 4),
    "Q" = c(1, 0),
    "R" = c(1, 1),
    "S" = c(1, 2),
    "T" = c(1, 3),
    "U" = c(1, 4),
    "V" = c(0, 0),
    "W" = c(0, 1),
    "X" = c(0, 2),
    "Y" = c(0, 3),
    "Z" = c(0, 4)
  )
  letter2 <- do.call(rbind, letter2)[, c("x", "y")]

  square_letter1 <- rownames(letter1)
  square_letter2 <- rownames(letter2)


  lookup_list <-
  lapply(
  c(1:dim(letter1)[1]),
  function(i) {
    numbers <- letter1[i,] + letter2

    cbind.data.frame(square_letters = paste0(square_letter1[i], square_letter2), numbers, stringsAsFactors = F)
  }
  )
  lookup <- as.data.frame(do.call(rbind, lookup_list), stringsAsFators = FALSE)

  return(lookup)
}

