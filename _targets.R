
library(targets)
library(tarchetypes)
source("packages.R")

invisible(list.files("R/", full.names = T, pattern = ".R") %>% lapply(source))


listing_page_url <- "https://www.realestate.com.au/sold/in-{postcode}/list-{page_number}?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate"

base_url <- "https://www.realestate.com.au/sold"
extract_pattern <- "/[^/]*$"


# https://www.realestate.com.au/sold/property-villa-qld-palmwoods-138614379

# property_url_df %>%
#     head(10) %>%
#     pull( property_url )

tar_plan(
    df =
        dir_ls("property_page_cache/archive/", glob = "*.html") %>%
            tibble(property_page = .) %>%
            mutate(row = row_number()) %>%
            # pluck("property_page") %>%
            mutate(details = map(property_page, extract_details_from_page)) %>%
            unnest(details) %>%
            mutate(url = property_page %>%
                str_extract(extract_pattern) %>%
                str_remove(".html$") %>%
                str_c(base_url, .)) %>%
            select(url, everything()),
    #
    cleaned_df = clean_property_details(df),
    #
    supplemented_df = supplement_property_details(cleaned_df),
    #
    write = supplemented_df %>% write_csv("output/property_details4.csv"),
    #
    write_qs = final %>% qs::qsave("output/property_details5.qs"),
    #
    sa1_seifa_decile =

        read_xls("data/2033055001 - sa1 indexes_seifa.xls", sheet = "Table 2", skip = 5) %>%
            janitor::clean_names() %>%
            mutate(sa1_7dig_2016 = as.character(x1)) %>%
            rename(decile = decile_7) %>%
            rename(population = x3) %>%
            select(sa1_7dig_2016, decile, score, population),
    #

    sa2_seifa_decile =

        read_xls("data/2033055001 - sa2 indexes.xls", sheet = "Table 2", skip = 5) %>%
            janitor::clean_names() %>%
            mutate(sa2_code_2016 = as.character(x1)) %>%
            rename(decile = decile_7) %>%
            rename(population = x3) %>%
            select(sa2_code_2016, decile, score, population)
            
            ,
    #

    property_location = TRUE

    ,

# search for NA and duplicate addresses
bad_lat_lon = 
    supplemented_df %>%
        select(url,  property.postcode, property.suburb, latitude_json, longitude_json) %>%
        count(latitude_json, longitude_json, sort=TRUE)  %>%
        filter(n > 1)  

,

# what addresses are associated with these bad lat/lon
bad_address = 
supplemented_df %>%
inner_join(bad_lat_lon, by = c("latitude_json", "longitude_json")) 

,

# geocode the bad addresses
geocoded_supplement = 

bad_address %>%
filter( !str_detect( address_f, "PO Box|Address available on request" ) ) %>%
distinct(  address_f ) %>%
geocode(address_f, method = 'arcgis')
,


# merge the geocoded addresses back into the main df
supplemented_geocoded =
supplemented_df %>%
left_join(geocoded_supplement, by = c("address_f")) %>%
mutate( latitude= ifelse( is.na(lat),latitude_json, lat)) %>%
mutate( longitude= ifelse( is.na(long),longitude_json, long)) %>%
select( url, latitude, longitude ) %>%
# create an sf object for the geocoded addresses
drop_na( latitude, longitude ) %>%
# use the crs of the sa1 shapefile
st_as_sf( coords = c("longitude", "latitude"), crs = st_crs( sa12016 ))

,

# what is the sa1 of the properties
sa1 = supplemented_geocoded %>%
st_join(sa12016) %>%
st_drop_geometry() 

,

# fill in the missing seifa sa1 decile and score with sa2 values
sa1_seifa = 

sa1 %>% 
left_join( sa1_seifa_decile,  by = "sa1_7dig_2016") %>%
left_join( sa2_seifa_decile, by = c("sa2_code_2016" = "sa2_code_2016")) %>%
select( url,  decile.x, score.x,  decile.y, score.y) %>%
mutate( decile = ifelse( is.na(decile.x), decile.y, decile.x)) %>%
mutate( score = ifelse( is.na(score.x), score.y, score.x)) %>%
select( url, seifa_decile = decile, seifa_score=score)


,

final = supplemented_df %>%
left_join( sa1_seifa, by = "url")  





,

    forsale =
        dir_ls("forsale/", glob = "*.html") %>%
            tibble(property_page = .) %>%
            mutate(row = row_number()) %>%
            mutate(details = map(property_page, extract_details_from_page)) %>%
            unnest(details) %>%
            mutate(url = property_page %>%
                str_extract(extract_pattern) %>%
                str_remove(".html$") %>%
                str_c(base_url, .)) %>%
            select(url, everything())
            #

            ,
 
    #
    cleaned_forsale = clean_property_details(forsale)
    #

    ,

    #
    supplemented_forsale = supplement_property_details(cleaned_forsale)
   #
    ,
    #
    write_forsale = supplemented_forsale %>% qs::qsave("output/forsale.qs"),
 


)
