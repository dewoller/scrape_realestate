
library(targets)
library(tarchetypes)
source("packages.R")

invisible( list.files('R/', full.names = T, pattern = ".R") %>% lapply( source) )

listing_page_url = 'https://www.realestate.com.au/sold/in-{postcode}/list-{page_number}?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate'


xpath_page_current='//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div[3]/div[1]/div[1]/div/div/div/nav/div[2]/a[1]'
xpath_page_last =  '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div[3]/div[1]/div[1]/div/div/div/nav/div[2]/a[5]'


# create a tar_map structure that gets each of the first pages for each postcode

# library(RSelenium)
# remDr <- remoteDriver(
# 	remoteServerAddr = "127.0.0.1",
# 	port = 4445L
# )
# remDr$open()

remDr=1

postcodes <- tibble(
  postcode=c(4553,4555,4556,4559,4561,4562,4560),
)

page_urls<- tar_map(
  values = postcodes
  ,tar_target( first_url , generate_url( listing_page_url, page_number=1, postcode))
  ,tar_target(first_page, get_listing_page( first_url, remDr)  )
  , tar_target( subsequent_url, generate_subsequent_url( listing_page_url, first_page))
   ,tar_target(subsequent_page, get_listing_page( subsequent_url, remDr)  )
  # )
  , tar_target( page, bind_rows( first_page, subsequent_page))
  )


get_pages = tar_map(
   tar_combine( name=pages, page_urls$page)
  # ,tar_target( property_url, extract_property_url( page))
  # ,tar_target( property, get_property_page( property_url ))
  # ,tar_target( details, get_property_details( property ))
)

# str( page_urls$page)

list(page_urls
   , get_pages
)


