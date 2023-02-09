

extract_details_from_page = function( property_page)  {

    attributes = list(
        category1=    '//*[@id="argonaut-wrapper"]/div[3]/div[1]/div/nav/ol/li[4]'
        , address1=   '//*[@id="argonaut-wrapper"]/div[3]/div[1]/div/nav/ol/li[5]'
        , address=    '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[1]/h1'
        , addressQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[1]/h1'
        , bedrooms =  '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[2]/div/div[1]/div[1]/p'
        , bedroomsQ = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[1]/p'
        , bathrooms = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[2]/div/div[1]/div[2]'
        , bathroomsQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[2]'
        , parking =   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[2]/div/div[1]/div[3]'
        , parkingQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[3]'
        , size =      '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[2]/div/div[2]'
        , sizeQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[2]'
        , price=      '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[2]/span[1]'
        , priceQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[1]'
        , category=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[1]/div[2]/span'
        , categoryQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/span'
        , sold_date=  '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/div[1]/div[2]/span[2]'
        , sold_dateQ=   '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[2]'
        , description='//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[2]/div[1]/div/div/article'
    )

    print( property_page)


    # /home/dewoller/code/dan/scrape_realestate/property_page_cache/archive/property-house-qld-belli+park-117432943.html
    property_page %>%
    readLines() %>%
    str_c(collapse='\n') %>%
    { . } -> property_page_text

    property_page %>%
        readLines() %>%
        str_c(collapse='\n') %>%
        { . } -> property_page_text

    if (property_page_text =='') return(tibble())

    # use xpath to extract the last script section from the html file
    # extract the json from the html file
    property_page_text %>%
        stringr::str_match('<script>(window.ArgonautExchange=(.*));</script>') %>%
        nth(3) %>%
        { . } -> test1

    if (is.na(test1)) {
        extracted_from_json = tibble()
     } else {

    test1 %>%
        jsonlite::fromJSON() %>%
        nth(1) %>%
        nth(1) %>%
        jsonlite::fromJSON() %>%
        nth(1) %>%
        nth(1) %>%
        jsonlite::fromJSON() %>%
        rrapply::rrapply(
            condition = \(x) !is.na(x),
            how = "flatten"
        ) %>%
        enframe() %>%
        filter(name != "__typename") %>%
        distinct() %>%
        mutate( name = str_c( name, '_json')) %>%
        group_by(name) %>%
        summarise(value = paste(value, collapse = ";")) %>%
        pivot_wider() %>%
        { . } -> extracted_from_json

     }





    pph = property_page_text %>% rvest::read_html()

    attributes %>%
        enframe( value='xpath_selector') %>%
        mutate( xpath_selector = unlist( xpath_selector)) %>%
        mutate( value = map2_chr( xpath_selector, name, function( x, y ) {
            # print(y)
            pph %>%
                rvest::html_nodes( xpath=x) %>%
                rvest::html_text() %>%
            { . } -> rv
            if( length(rv)==0)
            rv=NA
            rv
        })) %>%
        select( name, value ) %>%
        mutate( name = str_c(name, '_s' )) %>%
        pivot_wider( ) %>%
    { . } -> specific_attributes

    # bind_cols( specific_attributes, extracted_from_json)
    bind_cols( specific_attributes, extracted_from_json) 

}





