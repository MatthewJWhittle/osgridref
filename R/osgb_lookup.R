osgb_lookup <- function(){
  # First letter identifies the 500x500 km grid
  offset1 <- list(
    "S" = c(x = 0, y = 0),
    "T" = c(5, 0),
    "N" = c(0, 5),
    "H" = c(0, 10),
    "O" = c(5, 5)
  )
  offset1 <- do.call(rbind, offset1)
  
  # Second letter identifies the 100x100 km grid
  offset2 <- list(
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
  offset2 <- do.call(rbind, offset2)[, c("x", "y")]
  
  letter1 <- rownames(offset1)
  letter2 <- rownames(offset2)
  
  
  lookup <-
    c(1:dim(offset1)[1]) %>%
    lapply(function(i) {
      numbers <- offset1[i, ] + offset2
      
      cbind.data.frame(square_letters =  paste0(letter1[i], letter2), numbers, stringsAsFactors = F) 
    }) %>% bind_rows()
  
  as_tibble(lookup)
}

