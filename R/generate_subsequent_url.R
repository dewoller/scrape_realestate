generate_subsequent_url= function( listing_page_url, first_page)  {

xpath_pages =  '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div[3]/div[1]/div[1]/div/div/div/nav/div[1]'

  # find the html text of an element using xpath_page_last in first_page using rvest
  first_page %>%
    pull( listing_page) %>%
    rvest::read_html() %>%
    rvest::html_node(xpath=xpath_pages) %>%
    rvest::html_nodes(xpath='//a[@aria-label]') %>%
    map_chr( html_text ) %>%
    str_subset( '\\d+' ) %>%
    tibble('page_number'=.) %>%
    filter( page_number == max( page_number) ) %>%
    pull( page_number) %>%
    { . } -> npage


  tibble( page_number=2:npage, postcode=first_page$postcode) %>%
    mutate( url = glue::glue( listing_page_url )) %>%
    { . } -> rv






}

