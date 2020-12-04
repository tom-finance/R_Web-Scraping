################################################################################
# Use Banca d'Italia REST API for Exchange Rates with R
################################################################################

# package
library(httr)

################################################################################

# get historical series

# parameters for query
start <- "2000-11-29" # start date
end <- "2019-11-29" # end date
currency_base <- "USD" # base currency
currency_target <- "EUR" # target currency

path <- paste0("https://tassidicambio.bancaditalia.it/terzevalute-wf-web/rest/v1.0/dailyTimeSeries?startDate=",
               start, "&endDate=", end, "&baseCurrencyIsoCode=", currency_base, "&currencyIsoCode=",
               currency_target, "&lang=en")

# get latest rates for all currencies
path_latest <- "https://tassidicambio.bancaditalia.it/terzevalute-wf-web/rest/v1.0/latestRates?lang=en"


# run GET query (use proxy if necessary, e.g. in corporate environment)
r <- GET(url = path,
         use_proxy("10.139.200.69:8080"), # specify proxy
         accept("text/csv")) # specify header to GET request

# check status
status_code(r)

# check status is one of the following:
# 200 OK
# 500 Internal Server Error
# 503 Service Unavailable
# 400 Bad Request
# 408 Request Timeout
# 404 Not Found

# check content
str(content(r))

# get content into data frame
cont <- content(r, encoding = "UTF-8")

# plot some results
plot(cont$Rate ~ cont$`Reference date (CET)`,
     type = "l", col = "orangered", lwd = 2)

# Sources
# https://rpubs.com/plantagenet/481658
# https://rdrr.io/cran/httr/man/content_type.html
# https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
# https://github.com/ezin82/bankofitaly-exchangerates/tree/master/documentation

################################################################################
