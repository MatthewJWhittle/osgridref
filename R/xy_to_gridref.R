#' XY to Grid Ref
#'
#' Convert x and y coordinates to an osgb grid reference
#'
#' @param x a vector of x coordinates (must be epsg 27700)
#' @param y a vector of y coordinates (must be epsg 27700)
#' @param digits the number of digits to return (maximum value is 10)
#' @return a vector of osgb grid references
#' @importFrom magrittr %>%
#' @import dplyr
#' @export xy_to_gridref
xy_to_gridref <- function(x, y, digits = 10) {
  if(digits %% 2 != 0){stop("digits must be even")}

  stopifnot(length(x) == length(y))

  if(digits > 10){
    warning("Digits must be <= 10. Automatically changing to 10")
    digits <- 10
  }
  # Load the lookup table
  lookup <- osgb_lookup()

  # Define bounding boxes from the lookup table to compare with grid references
  lookup_bbox <-
    lookup %>%
    mutate(
      xmin = paste0(.data$x, "00000") %>% as.numeric(),
      ymin = paste0(.data$y, "00000") %>% as.numeric(),
      xmax = .data$xmin + 100000,
      ymax = .data$ymin + 100000
    )

  # Work out which square each grid ref is within and return the letters
  letters <-
    lapply(seq_along(x), function(i) {
      match <-
        x[i] >= lookup_bbox$xmin &
        x[i] < lookup_bbox$xmax &
        y[i] >= lookup_bbox$ymin &
        y[i] < lookup_bbox$ymax
      #print(paste0(i, "-", which(match)))
      lookup_bbox$square_letters[which(match)]
    }) %>% unlist()

  # make the coordinates into an xy and join the square lookup
  conversion_table <-
    tibble(coord_x = x,
           coord_y = y,
           letters = letters) %>%
    left_join(lookup_bbox, by = c("letters" = "square_letters")) %>%
    # remove the first digit from each coordinate and remove any digits from the end
    mutate(
      out_x = substr(.data$coord_x, nchar(.data$x) + 1, stop  = (.data$digits  / 2) + 1),
      out_y = substr(.data$coord_y, nchar(.data$x) + 1, stop  = (.data$digits  / 2) + 1),
      # Paste the components together with a space seperating them
      osgb = paste(.data$letters, .data$out_x, .data$out_y)
    )

  # Return the grid reference
  conversion_table$osgb


}
