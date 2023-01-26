get_property_page = function( property_url_df, remDr ) {


  cd <- cachem::cache_disk( dir = "web_page_cache", max_size=Inf)

  mgpp = memoise::memoise(get_property_page_actual , cache = cd)


  property_url_df %>%
    mutate( property_page = map( property_url, ~mgpp(.x))) %>%
    { . } -> rv

  rv
}


get_property_page_actual = function( property_url) {
  # wait for 1 second
  tictoc::tic( msg=property_url)
  remDr$navigate( property_url )
  Sys.sleep( 1 )
  tictoc::toc( )
  remDr$getPageSource()[[1]]

}
