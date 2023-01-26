generate_url = function( listing_page_url, page_number, postcode) {

  tibble( url= glue::glue( listing_page_url ),
  postcode=postcode,
  page_number=page_number )


}
