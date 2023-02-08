
library(targets)
library(tarchetypes)
source("packages.R")

invisible( list.files('R/', full.names = T, pattern = ".R") %>% lapply( source) )

listing_page_url = 'https://www.realestate.com.au/sold/in-{postcode}/list-{page_number}?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate'

base_url= "https://www.realestate.com.au/sold"
extract_pattern= "/[^/]*$"


https://www.realestate.com.au/sold/property-villa-qld-palmwoods-138614379

property_url_df %>%
	head(10) %>%
	pull( property_url )

tar_plan(


df=dir_ls('property_page_cache/archive/', glob='*.html') %>%
d	tibble( property_page = .) %>%
	mutate( row = row_number()) %>%
	# head(24) %>%
	# tail(1) %>%
	# pluck( 'property_page') %>%
	# { . } -> property_page
	mutate( details = map2( property_page, row, extract_details_from_page )) %>%
	unnest( details ) %>%
	mutate( url = property_page %>%
		str_extract( extract_pattern) %>%
		str_remove( '.html$') %>%
		str_c( base_url, .) ) %>%
	select( url, everything() )

,

write = df %>% write_csv( 'output/property_details.csv')

)
