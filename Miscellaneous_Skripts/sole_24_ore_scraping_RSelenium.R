################################################################################
# R Script do Automate Download from Website with javascript Elements
#
# (c) Thomas Ludwig, September 2020.
################################################################################

# packages
library(RSelenium)

################################################################################

# set up driver
driver <- rsDriver(browser=c("chrome"), # I use Chrome because Firefox causes trouble with download
                   chromever="85.0.4183.83", # have to manually set this, otherwise problems
                   port = 2000L) # select port, this setting should work out fine normally

# navigate to website of interest, in this case Consob website where we can download the file 
driver$client$navigate("https://mercati.ilsole24ore.com/obbligazioni/spread/btp-10a-bund-10a")

driver$client$findElement(using = 'css selector',
                          "#wrapper > div.s24-main-content > div.s24-main-content > div.container.s24-main-container > section:nth-child(3) > div > div.col-lg-8 > div:nth-child(2) > div > div > div > div.am-bounds > div.chartTop.cf > div.periodSelector > a:nth-child(6)")$click()

# close server and client, otherwise problems with RSelenium
driver$server$stop()
driver$client$quit()

#############
#############