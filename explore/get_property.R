
property_url_df %>%
	write_csv( 'output/property_url_df.csv' )

property_url = "https://www.realestate.com.au/sold/property-house-qld-hunchy-140829672"
property_url ="https://www.realestate.com.au/sold/property-residential+land-qld-palmview-203405987"

library(RSelenium)
remDr <- RSelenium::remoteDriver(
	remoteServerAddr = "127.0.0.1",
	port = 4444L,
	# extraCapabilities = list(chromeOptions = list( args = c('--incognito')))
)
remDr$open( silent=TRUE )

remDr$navigate( property_url )

rv=remDr$getPageSource()[[1]]
count=0
while (str_detect(rv, 'window.ArgonautExchange') & count < 30) {
  Sys.sleep( 1 )
  count = count+1
  if count>60 {
		stop(str_c( "cannot get window.ArgonautExchange in 60 seconds at \n", property_url, '\n'))
	}
  rv=remDr$getPageSource()[[1]]
}
rv

  b=remDr$getPageSource()[[1]]

a==b

  c=remDr$getPageSource()[[1]]

c==b

  d=remDr$getPageSource()[[1]]


c %>%
read_html() %>%
html_nodes("script") %>%

a %>%
read_html() %>%
html_nodes("script") %>%

str_detect(a, 'window.ArgonautExchange')

str_detect(b, 'window.ArgonautExchange')


}
