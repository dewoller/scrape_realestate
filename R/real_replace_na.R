real_replace_na = function( x, y) {
  map2_chr( x, y, ~ ifelse( is.na(.x), .y, .x)) 
}
