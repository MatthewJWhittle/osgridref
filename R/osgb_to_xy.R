require(tidyverse)
osgb_to_xy <- function(x) {
  # Get the square letters and numbers
  square_letters <- str_extract(x, "^[a-zA-Z]{2}") %>% str_to_upper()
  numbers <- str_extract(x, "[0-9]+ ?[0-9]+") %>% str_remove_all(" ")
  
  # Split the numbers into x and y
  # Get the resolution from number of digits
  digits <- nchar(numbers)
  uneven_digits <- !(digits %% 2 == 0)
  
  # Set invalid grid references to NA
  numbers[uneven_digits] <- NA
  
  # Split for later addition
  coord_digits <- digits / 2
  grid_x <- substr(numbers, 1, coord_digits)
  grid_y <- substr(numbers, coord_digits + 1, digits)
  
  # Calculate te resolution
  resolution <- 10 ^ (5 - coord_digits)
  
  x_num <- as.numeric(grid_x) * resolution
  y_num <- as.numeric(grid_y) * resolution
  
  # Build a tibble of in data
  in_coords <-
    dplyr::tibble(
      in_letters = square_letters,
      in_ref = x,
      resolution = resolution,
      in_x = x_num,
      in_y = y_num
    )
  
  # Get the osgb square lookup
  lookup <- osgb_lookup() %>%
    dplyr::mutate(
      xmin = paste0(x, "00000") %>% as.numeric(),
      ymin = paste0(y, "00000") %>% as.numeric()
    )
  
  
  # Perform a joins operation to match up the grid refs with their squares
  out_coords <-
    in_coords %>%
    dplyr::left_join(lookup,
                     by = c("in_letters" = "square_letters")) %>%
    dplyr::mutate(out_x = xmin + in_x,
                  out_y = ymin + in_y)
  
  # Select and rename variables for clean output
  out_coords <-
    out_coords %>%
    dplyr::select(x = out_x, y = out_y, resolution)
  # This could return a spatial object but would have to deal with NA values
  return(out_coords)
}
