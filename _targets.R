
library(targets)
library(tarchetypes)
source("packages.R")

invisible( list.files('R/', full.names = T, pattern = ".R") %>% lapply( source) )

listing_page_url = 'https://www.realestate.com.au/sold/in-{postcode}/list-{page_number}?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate'

base_url= "https://www.realestate.com.au"
extract_pattern= "/sold/.*[0-9]{8}$"



# create a tar_map structure that gets each of the first pages for each postcode

library(RSelenium)
remDr <- RSelenium::remoteDriver(
	remoteServerAddr = "127.0.0.1",
	port = 4444L,
	extraCapabilities = list(chromeOptions = list( args = c('--incognito')))
)
a=remDr$open( )



postcodes <- tibble(
  postcode=c(4553, 4555,4556,4559,4561,4562,4560),
  # postcode=c(4553),
  # postcode=c(4555),
)

listing_page <- tar_map(
  values = postcodes
  ,tar_target( first_listing_page_info , generate_url( listing_page_url, page_number=1, postcode))
  ,tar_target(first_page, get_listing_page( first_listing_page_info )  )
  , tar_target( subsequent_listing_page_info, generate_subsequent_url( listing_page_url, first_page))
  ,tar_target(subsequent_page, get_listing_page( subsequent_listing_page_info)  )
  # )
  , tar_target( postcode_page, bind_rows( first_page, subsequent_page))
)


property_page = tar_plan(
  tar_combine( combined_listing
    , listing_page$postcode_page
    , command = dplyr::bind_rows(!!!.x)
  )
  ,tar_target( property_url_df, extract_property_url( combined_listing, base_url,extract_pattern   ))

  ,tar_target( property, get_property_page( property_url_df, remDr )
    , pattern=map( property_url_df))
  ,tar_target( details, get_property_details( property ))
)

# str( page_urls$page)

list(listing_page
  , property_page
)

