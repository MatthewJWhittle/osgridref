require(tidyverse)
require(sf)

osgb_square <-
  function(x, digits) {
    if(digits %% 2 != 0){stop("digits must be even")}
    coords <-  x %>% st_coordinates()
    coord_x <- coords[, 1] %>% round()
    coord_y <- coords[, 2] %>% round()
    lookup <- osgb_lookup()
    
    lookup_bbox <-
      lookup %>%
      mutate(
        xmin = paste0(x, "00000") %>% as.numeric(),
        ymin = paste0(y, "00000") %>% as.numeric(),
        xmax = xmin + 100000,
        ymax = ymin + 100000
      )
    
    # This is returning two squares for a coord
    letters <- 
      lapply(seq_along(coord_x), function(i) {
      match <-
        coord_x[i] >= lookup_bbox$xmin &
        coord_x[i] < lookup_bbox$xmax &
        coord_y[i] >= lookup_bbox$ymin & coord_y[i] < lookup_bbox$ymax
      #print(paste0(i, "-", which(match)))
      lookup_bbox$square_letters[which(match)]
    }) %>% unlist() 
    
    
    conversion_table <- 
      tibble(coord_x = coord_x,
           coord_y = coord_y, 
           letters = letters) %>% 
      left_join(lookup_bbox, by = c("letters" = "square_letters")) %>% 
      mutate(out_x = substr(coord_x, nchar(x) + 1, stop  = (digits  / 2) + 1),
             out_y = substr(coord_y, nchar(x) + 1, stop  = (digits  / 2) + 1),
             osgb = paste0(letters, out_x, out_y)
             ) 
      
    
    unique(conversion_table$osgb)
    
  }
