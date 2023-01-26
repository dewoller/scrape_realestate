get_listing_page = function( listing_page_info ) {

  remDr <- remoteDriver(
    remoteServerAddr = "127.0.0.1",
    port = 4445L
  )
  remDr$open()

  listing_page_info %>%
    mutate( listing_page=map_chr( url, function( x ) {
      remDr$navigate( x )
      Sys.sleep( 1 )
      remDr$getPageSource()[[1]]
    }) ) %>%
    { . } -> rv

  remDr$close()

  rv
}
