#!/usr/bin/Rscript

attributes = list(
	  address=    '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[1]/h1'
	, bedrooms =  '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[1]/p'
	, bathrooms = '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[2]'
	, parking =   '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[1]/div[3]'
	, size =      '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/div/div[2]'
	, category=   '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]/span'
	, price=      '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[1]'
	, sold_date=  '/html/body/div/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]/span[2]'
	, description='/html/body/div/div[3]/div[3]/div[2]/div[1]/div/div/article/div'
)

property %>%
	mutate( pp = unlist( property_page)) %>%
	head(2) %>%
	tail(1) %>%
	pull(pp ) %>%
	{ . } -> property_page

property_page %>% clipr::write_clip()


property %>%
	mutate( pp = unlist( property_page)) %>%
	mutate( details = map( pp, extract_details_from_page)) %>%
	unnest(details) %>%
	{ . } -> rv


rv

library(tidytext)

bigrams = 
supplemented_df %>%
select( url, description_f) %>%
  unnest_tokens(bigram, description_f, token = "ngrams", n = 2)

  bigrams %>% 
  count( bigram, sort=TRUE) %>%
  {.} -> bg_count

data(stop_words)

tidytext::stop_words  %>%
  filter( lexicon=='SMART') %>%
  {.} -> stopwords

bg_count %>%
separate( bigram, c('a','b'), sep=' '   ) %>%
filter( !a %in% stopwords$word & !b %in% stopwords$word) %>%
{.} -> bg_count_filtered


e
filter()
  head(100) %>%
  pull( n )



