search_query_skeleton="https://www.realestate.com.au/sold/with-4-bedrooms-in-nambour,+qld+4560%3b+doonan,+qld+4562%3b+yandina,+qld+4561/list-{page}?maxBeds=4&source=refinement"


get_links_xpath ='//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div[3]/div[1]/div[1]/div/*/article/div[4]/div/div[1]/div[2]/h2/a'

property_details_xpath = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]'

property_price_xpath = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]'

read_more_xpath='/html/body/div[1]/div[3]/div[3]/div[2]/div[1]/div/div/article/div/button/p'



library("RSelenium")
rsDriver(chromever = "108.0.5359.40", browser = "chrome", extraCapabilities = eCaps)
rsDriver(chromever = "109.0.5414.25", browser = "chrome", extraCapabilities = eCaps)

rsDriver(chromever = "109.0.5414.74", browser = "chrome", extraCapabilities = eCaps)

rsDriver(chromever = "110.0.5481.30", browser = "chrome")


driver = rsDriver(port = 4841L, browser = c("firefox"))

rsDriver(browser='firefox')

selServ <- wdman::selenium(verbose = TRUE)
selServ$log



binman::list_versions("seleniumserver")

rsDriver(browser = c('firefox'))

library(wdman)
selServ <- wdman::selenium(verbose = FALSE)
selServ$log()


library(RSelenium)
library(wdman)
selServ <- wdman::selenium(retcommand = TRUE, verbose = FALSE)


rd <- rsDriver(port = 4567L, browser = "chrome")

selServ $server$log()

remDr <- remoteDriver()
remDr
remDr$open()

################################################################################

user_agent_list = c ("Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0", "Mozilla/5.0 (Windows NT 6.1; r
v:27.3) Gecko/20130101 Firefox/27.3", "Mozilla/5.0 (X11; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0", "Mozilla/5.
0 (Windows NT 6.2; Win64; x64;) Gecko/20100101 Firefox/20.0", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.
36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/
537.36 (KHTML, like Gecko) Chrome/41.0.2226.0 Safari/537.36", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKi
t/537.36 (KHTML, like Gecko) Chrome/32.0.1664.3 Safari/537.36", "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML,
like Gecko) Chrome/27.0.1453.93 Safari/537.36","Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chro
me/27.0.1453.90 Safari/537.36", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Ubuntu/11.04 Chro
mium/17.0.963.56 Chrome/17.0.963.56 Safari/535.11")
fprof <- makeFirefoxProfile(list(general.useragent.override=sample(user_agent_list,1)))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, extraCapabilities = fprof )



################################################################################

mybrowser <- remoteDriver(browser = "firefox")

mybrowser$open()

library(RSelenium)
remDr <- remoteDriver(
	remoteServerAddr = "localhost",
	port = 4445L
)
remDr$open()



remDr$navigate('https://www.realestate.com.au/sold/in-4555/list-1?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate')


remDr$navigate(url)

binman::list_versions("chromedriver")

property_url_df %>%
	head(1) %>%
	pull( url ) %>%
	as.character() %>%
	{ . } -> url

https://www.realestate.com.au/sold/in-4555/list-1?maxBeds=4&misc=ex-no-sale-price&activeSort=solddate

	 remDr$navigate( as.character( url ))

property_url_df %>%
	head(1) %>%
	pull( property_url ) %>%
	 remDr$navigate(  )

property_url = "https://www.realestate.com.au/sold/property-terrace-qld-palmview-140959172"
 	remDr$navigate( property_url )
remDr$executeScript(  "window.scrollBy(0,900)")

a=remDr$findElement(using="xpath",read_more_xpath)

a$clickElement()


for i in 1:50 {
	search_query <- gsub("{page}", i, search_query_skeleton)
	remDr$navigate(search_query)

	url_nodes=remDr$findElements(using='xpath',get_links_xpath)

	# extract href from each element
	hrefs=unlist(lapply(url_nodes, function(x) x$getElementAttribute('href')))


	# for all hrefs, extract property details
	# need to do the following for each href (and each href on each subsequent page)
	# here is an example for the first one
	remDr$navigate(hrefs[1])

	# get details, e.g. "4\n2\n2\n 717\nm²\nHouse"
	details=remDr$findElement(using='xpath', property_details_xpath)$getElementText()

	# get price, e.g.  "$829,000\nSold on 14 Dec 2022"
	price=remDr$findElement(using='xpath', property_price_xpath)$getElementText()

	# probably want to get the text also
	# use chrome to find the xpath for the text
	# you might have to get selelium to click on the read all  first

	# store everything in a dataframe

}

# write dataframe to csv










