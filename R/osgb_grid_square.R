osgb_grid_square <-
  function(x) {
    coords <-  x %>% st_coordinates()
    coord_x <- coords[, 1]
    coord_y <- coords[, 2]
    lookup <- osgb_lookup()
    
    lookup <-
      lookup %>%
      mutate(
        xmin = paste0(x, "00000") %>% as.numeric(),
        ymin = paste0(y, "00000") %>% as.numeric(),
        xmax = xmin + 100000,
        ymax = ymin + 100000
      ) %>%
      select(-x, -y)
    
    
    lapply(seq_along(x), function(i) {
      match <-
        coord_x[i] >= lookup$xmin &
        coord_x[i] < lookup$xmax &
        coord_y[i] >= lookup$ymin & coord_y[i] < lookup$ymax
      lookup$square_letters[which(match)]
    }) %>% unlist() %>% unique()
    
  }