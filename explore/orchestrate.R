
save_all_pages = function ( property_url_df )  {

	current_url=''
	count=0

	property_url_df %>%
		# return( property_page_filename( property_url) %>% readLines())
		mutate( order = sample( n(), n())) %>%
		arrange( order ) %>%
		mutate( page = map2( url, property_url, get_property_page_browser)) %>%
		{ . } -> rv


}


get_property_page_browser = function( url, property_url) {


	print(property_url )

	tictoc::tic( msg=property_url )
	if (property_page_exists( property_url)) {
		print('page already exists')
		tictoc::toc()
		return()
	}



	# if (url != current_url) {
	# 	navigate_to( url )
	# 	Sys.sleep(10)+ sample( 10, 1 )
	# 	current_url = url
	# }

	navigate_to( property_url )
	Sys.sleep(25) + sample( 10, 1 )
	save_page( property_page_filename( property_url ) )
	# count = count + 1
	# if (count > 20+sample(50,1)) {
	# 	restartVPN()
	# 	Sys.sleep(30)
	# 	count=0
	# }
	Sys.sleep(25)

	tictoc::toc()
	# return( property_page_filename( property_url) %>% readLines())

}


navigate_to = function( url ) {

	# run an ls command in the terminal

	system('i3-msg \'[class="Chromium-browser"] focus\'')
	Sys.sleep(1)
	system(str_c( 'xdotool key Escape'))
	system(str_c( 'xdotool key ctrl+l'))
	Sys.sleep(1)
	system(str_c( 'xdotool type "', url, ' "'))

	Sys.sleep(3)
	system('xdotool key Return')

}

save_page = function( filename ) {

	partial_filename = str_replace( filename, '.html$', '')
	system(str_c( 'xdotool key ctrl+s '))
	 	Sys.sleep(1)
	 system( str_c( 'xdotool type "', partial_filename, '"'))
	Sys.sleep(1)
	system('xdotool key Return')


}
