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

	
	%>%
{ . } -> bigrams

bigrams = 
supplemented_df %>%
select( url, description_f) %>%
  unnest_tokens(bigram, description_f, token = "ngrams", n = 2)

trigrams = 
supplemented_df %>%
select( url, description_f) %>%
  unnest_tokens(trigram, description_f, token = "ngrams", n = 3)

  trigrams %>% 
  count( trigram, sort=TRUE) %>%
  {.} -> trg_count

  bigrams %>% 
  count( bigram, sort=TRUE) %>%
  {.} -> bg_count

data(stop_words)

tidytext::stop_words  %>%
  filter( lexicon=='SMART') %>%
  {.} -> stopwords

trg_count %>%
separate( trigram, c('a','b', 'c'), sep=' ' , remove=FALSE  ) %>%
filter( !a %in% stopwords$word & !b %in% stopwords$word & !c %in% stopwords$word) %>%
{.} -> trg_count_filtered

bg_count %>%
separate( bigram, c('a','b'), sep=' ' , remove=FALSE  ) %>%
filter( !a %in% stopwords$word & !b %in% stopwords$word) %>%
{.} -> bg_count_filtered

bg_count_filtered %>%
head(100)  %>%
write_csv( 'bigram_count.csv')

trg_count_filtered %>%
head(100)  %>%
write_csv( 'trigram_count.csv')






quigrams = 
supplemented_df %>%
select( url, description_f) %>%
  unnest_tokens(quigram, description_f, token = "ngrams", n = 4)

  quigrams %>% 
  count( quigram, sort=TRUE) %>%
  {.} -> qug_count

qug_count %>%
separate( quigram, c('a','b', 'c', 'd'), sep=' ' , remove=FALSE  ) %>%
filter( !a %in% stopwords$word & 
!b %in% stopwords$word & 
!c %in% stopwords$word &
!d %in% stopwords$word
) %>%
{.} -> qug_count_filtered

qug_count_filtered %>%
head(100)  %>%
write_csv( 'quigram_count.csv')