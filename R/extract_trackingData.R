
extract_trackingData <- function(x) {

  x %>%
    jsonlite::fromJSON() %>%
    map(~ .$data) %>%
    {.} -> a

a[['agents']]=NULL

a %>%
    as.data.frame() %>%
    select(-starts_with("agents")) %>%
    distinct()

}