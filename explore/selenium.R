search_query_skeleton="https://www.realestate.com.au/sold/with-4-bedrooms-in-nambour,+qld+4560%3b+doonan,+qld+4562%3b+yandina,+qld+4561/list-{page}?maxBeds=4&source=refinement"


get_links_xpath ='//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div[3]/div[1]/div[1]/div/*/article/div[4]/div/div[1]/div[2]/h2/a'

property_details_xpath = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[1]/div[2]'

property_price_xpath = '//*[@id="argonaut-wrapper"]/div[3]/div[3]/div[1]/div/div/div[1]/div/div[2]'



library(RSelenium)
remDr <- remoteDriver(
	remoteServerAddr = "127.0.0.1",
	port = 4445L
)
remDr$open()


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










