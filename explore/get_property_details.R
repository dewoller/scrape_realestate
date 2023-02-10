



# extract property details from a property page
get_property_details = function( property )  {


  property %>%
    head(2) %>%
    tail(1) %>%
    mutate( pp = unlist( property_page)) %>%
    mutate( details = map2( pp,   extract_details_from_page)) %>%
    unnest(details) %>%
    { . } -> rv


  rv

}

a =read_csv('output/property_details3.csv')

real_replace_na = function( x, y) {
  map2_chr( x, y, ~ ifelse( is.na(.x), .y, .x)) 
}

a %>%
select( ends_with('Q_s'))  %>% clipr::write_clip()

tar_load( df )


clean_property_details = function( df ) {
df %>%
mutate( address_f = real_replace_na( address_s,addressQ_s )) %>%
mutate( bedrooms_f = real_replace_na( bedrooms_s,bedroomsQ_s )) %>%
mutate( bathrooms_f = real_replace_na( bathrooms_s,bathroomsQ_s )) %>%
mutate( parking_f = real_replace_na( parking_s,parkingQ_s )) %>%
mutate( size_f = real_replace_na( size_s,sizeQ_s )) %>%
mutate( price_f = real_replace_na( price_s,priceQ_s )) %>%
mutate( category_f = real_replace_na( category_s,categoryQ_s )) %>%
mutate( sold_date_f = real_replace_na( sold_date_s,sold_dateQ_s )) %>%
rename( description_f =  description_s) %>%
select( -ends_with('_s'), -avgRating_json, -displayLabel_json,
-totalReviews_json, -agentId_json, -disclaimerType_json,
-templated_json ) 

}


extract_trackingData <- function(x) {
  x %>%
    jsonlite::fromJSON() %>%
    map(~ .$data) %>%
    as.data.frame() %>%
    select(-starts_with("agents")) %>%
    distinct()
}









%>%
filter( value > 4000 ) %>%
pull( name ) %>% str_c( collapse=',\n') %>% clipr::write_clip()

 %>%
{.} -> c

{.} -> c
names() %>%
str_c( collapse=',\n') %>% clipr::write_clip()

summary()

-avgRating_json,
-displayLabel_json,
-totalReviews_json,
-agentId_json,
-disclaimerType_json,
-templated_json
-
)
{.} -> c