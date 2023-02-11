clean_property_details <- function(df) {
    df %>%
        mutate(address_f = real_replace_na(address_s, addressQ_s)) %>%
        mutate(bedrooms_f = real_replace_na(bedrooms_s, bedroomsQ_s)) %>%
        mutate(bathrooms_f = real_replace_na(bathrooms_s, bathroomsQ_s)) %>%
        mutate(parking_f = real_replace_na(parking_s, parkingQ_s)) %>%
        mutate(size_f = real_replace_na(size_s, sizeQ_s)) %>%
        mutate(price_f = real_replace_na(price_s, priceQ_s)) %>%
        mutate(category_f = real_replace_na(category_s, categoryQ_s)) %>%
        mutate(sold_date_f = real_replace_na(sold_date_s, sold_dateQ_s)) %>%
        rename(description_f = description_s) %>%
        select(
            -ends_with("_s"),
            -starts_with("avgRating_json"),
            -starts_with("displayLabel_json"),
            -starts_with("totalReviews_json"),
            -starts_with("agentId_json"),
            -starts_with("disclaimerType_json"),
            -starts_with("templated_json")
        )
}
