#' Convert Grid Ref to XY
#'
#' This function converts ordinance survey grid references to eastings northing
#'
#' @param x A vector of ordinance survey grid references such as 'TA 123 231'
#' @return A tibble of eastings and northings coordinates and their resolution
#' @importFrom stringr str_extract str_remove_all
#' @importFrom magrittr %>%
#' @importFrom dplyr tibble mutate left_join select
#' @importFrom rlang .data
#' @export
gridref_to_xy <- function(x) {

  # Assert that x is a character vector
  character_vector <- is.vector(x) && is.character(x)
  if(!character_vector){
    stop("x is not a character vector")
  }
  # Get the square letters and numbers using regex
  square_letters <- toupper(str_extract(x, "^[a-zA-Z]{2}"))
  numbers <- str_extract(x, "[0-9]+ ?[0-9]+") %>% str_remove_all(" ")

  # Create a null return
  null_conversion <- tibble(x = NA, y = NA, resolution = NA)

  # Split the numbers into x and y
  # Get the resolution from number of digits
  digits <- nchar(numbers)
  uneven_digits <- !(digits %% 2 == 0)

  # Test that the square letters have been extracted properly
  bad_format_letters <- is.na(square_letters) | !(nchar(square_letters) == 2)

  # Check for test failure
  invalid_ref <- uneven_digits | bad_format_letters

  # Set invalid grid references to NA
  numbers[invalid_ref] <- NA

  # Split for later addition
  coord_digits <- digits / 2
  grid_x <- substr(numbers, 1, coord_digits)
  grid_y <- substr(numbers, coord_digits + 1, digits)

  # Calculate the resolution
  resolution <- 10 ^ (5 - coord_digits)

  x_num <- as.numeric(grid_x) * resolution
  y_num <- as.numeric(grid_y) * resolution

  # Build a tibble of in data
  in_coords <-
    dplyr::tibble(
      in_letters = square_letters,
      in_ref = as.character(x),
      resolution = resolution,
      in_x = x_num,
      in_y = y_num
    )

  # Get the osgb square lookup
  lookup <- osgb_lookup() %>%
    dplyr::mutate(
      xmin = as.numeric(paste0(.data$x, "00000")),
      ymin = as.numeric(paste0(.data$y, "00000"))
    )


  # Perform a joins operation to match up the grid refs with their squares
  out_coords <-
    in_coords %>%
    dplyr::left_join(lookup,
                     by = c("in_letters" = "square_letters")) %>%
    dplyr::mutate(out_x = .data$xmin + .data$in_x,
                  out_y = .data$ymin + .data$in_y)

  # Select and rename variables for clean output
  out_coords <-
    out_coords %>%
    dplyr::select(x = .data$out_x, y = .data$out_y, .data$resolution)

  # If any of the grid references are invalid (not meeting tests)
  # then replace them with NA and print a warning message
  if(any(invalid_ref)){
    out_coords[invalid_ref, ] <- NA
    warning(paste0(sum(invalid_ref), " grid reference(s) failed to parse." ))
  }

  # This could return a spatial object but would have to deal with NA values
  return(out_coords)
}
