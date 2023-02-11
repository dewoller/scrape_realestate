
calculate_ngram = function( df, n=2) {
  unnest_tokens(df, n_gram, description_f, token = "ngrams", n = n)
}

stopwords_re <- function() {
    data(stop_words)
    tidytext::stop_words %>%
        filter(lexicon == "SMART") %>%
        pull(word) %>%
        str_c(collapse = "|") %>%
        str_c("( |^)(", ., ")( |$)")
}



# eliminage ngrams with stopwords
filter_ngram = function( df ) {

df %>%
filter( !str_detect( n_gram, stopwords_re() ) ) 
}


count_ngram = function( df ) {
df %>%
    count( n_gram, sort=TRUE) 

}

test = function() {

tibble( n = 1:4 ) %>%
mutate( df = map( n, calculate_ngram, df = supplemented_df)) %>%
mutate( df = map( df, count_ngram)) %>%
mutate( df = map( df, filter_ngram))  %>%
{.} -> ngram_df

ngram_df

}