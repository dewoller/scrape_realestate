extract_property_url = function( combined_listing,

                                base_pattern= "https://www.realestate.com.au/sold/",
                                extract_pattern= "/sold/.*[0-9]{8}$"
                                ) {



  combined_listing %>%
    # head(1) %>%
    mutate( property_url = map( listing_page, function( x ) {
      rvest::read_html( x) %>%
        rvest::html_nodes( xpath='//a') %>%
        rvest::html_attr('href') %>%
        str_subset( extract_pattern) %>%
        unique()
    })) %>%
    select( -listing_page) %>%
    unnest(property_url) %>%
    mutate( property_url = str_c( base_pattern, property_url)) %>%
    { . } -> rv

  rv


}
