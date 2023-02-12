tar_load( supplemented_df)



supplemented_df %>%
head(10) %>%
{.} -> df


final %>%
select( ends_with( 'pf')) %>%
{.} -> final_pf