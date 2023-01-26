

# extract property details from a property page
get_property_details = function( property )  {


	property %>%
		mutate( pp = unlist( property_page)) %>%
		mutate( row_number = row_number()) %>%
		mutate( details = map2( pp,  row_number, extract_details_from_page)) %>%
		{ . } -> x

x %>%
		head(370) %>%
		# select(details) %>%
unnest(details) %>%
		write_csv('output/property_details.csv')



		{ . } -> rv


	x %>%
		select( details ) %>%
		mutate( y = map( details, is_tibble)) %>%
		count( y )


		map( )
		count( is_tibble( unlist(details))) %>%
		{ . } -> rv


		unnest(details) %>%
		{ . } -> rv


	rv

}


