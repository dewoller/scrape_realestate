fs::dir_ls( '/etc/openvpn/nordvpn/ovpn_udp/', glob='*au*') %>%
	c( fs::dir_ls( '/etc/openvpn/nordvpn/ovpn_tcp/', glob='*au*')) %>%
	{ . } -> possible_vpn_clients

property_page_cache = 'property_page_cache'

get_property_page = function( property_url_df, remDr ) {


  fs::dir_create( property_page_cache)
  # cd <- cachem::cache_disk( dir = "web_page_cache", max_size=Inf)
  # mgpp = memoise::memoise(get_property_page_actual , cache = cd)

# put tibble in random order
  property_url_df %>%
  	mutate( random = sample(nrow(.))) %>%
  	arrange( random) %>%
  	select(-random ) %>%
    mutate( property_page = map( property_url, ~get_property_page_actual(.x))) %>%
    { . } -> rv

  rv
}

################################################################################
property_page_filename = function( property_url) {
  str_extract( property_url, '/[^/]*$') %>%
    str_c(property_page_cache, ., '.html')
}

################################################################################
property_page_exists = function( property_url) {
  property_page_filename( property_url) %>%
    fs::file_exists()

}

if(FALSE)
property_url = "https://www.realestate.com.au/sold/property-terrace-qld-palmview-140959172"

################################################################################
get_property_page_actual = function( property_url) {

	print(property_url )
  tictoc::tic( msg=property_url )
  if (property_page_exists( property_url)) {
    tictoc::toc()
    return( property_page_filename( property_url) %>% readLines())
  }


	# get the page, reload vpn
	reload_chrome_driver( property_url)
  remDr$executeScript( str_c( "window.scrollBy(0,", 50 + sample( 100,1 ), ");"))
  Sys.sleep(1)
  rv=remDr$getPageSource()[[1]]
  count=1
  while (str_detect(rv, 'window.ArgonautExchange') & count < 30) {
   count = count+1
    if (count>120) {
      stop(str_c( "cannot get window.ArgonautExchange downloading property URL in 120 seconds at \n",
        property_url,
        '\n'))
    }
  remDr$executeScript( str_c( "window.scrollBy(0,", 50 + sample( 100, 1 ), ");"))
    Sys.sleep( 1 )
    rv=remDr$getPageSource()[[1]]
  }

	if( count < 10 ) {
    Sys.sleep( 2 )
    rv=remDr$getPageSource()[[1]]
	}
  tictoc::toc( )

  # write html to file
  con <- base::file(property_page_filename( property_url ), open = "w+b")
  on.exit(close(con), add = TRUE)
  writeLines(rv, con, useBytes = TRUE)

  rv

}

################################################################################
 reload_chrome_driver = function( property_url) {
 	remDr$close()
 	remDr$quit()
 	restartVPN()
 	Sys.sleep(2 - sample(1000)/1000)
 	remDr$open( silent=TRUE )
 	remDr$navigate( property_url )
 	remDr
 }

################################################################################
 restartVPN = function( ) {

	# pick a random VPN server

		possible_vpn_clients %>%
		tibble::tibble( vpn_file = .) %>%
		sample_n(1) %>%
		pull( vpn_file ) %>%
		{ . } -> vpn_file

	# print( vpn_file )

	# stop the current vpn
	system( 'sudo pkill openvpn')

	# start the new vpn
	 system( str_c( 'sudo openvpn --mute-replay-warnings  --daemon --config ', vpn_file))

 }




