
#' Form a request URL
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @param page page number. The default value is 1.
#' @return a request URL
#' @importFrom httr GET
#' @export
#'

get_request <- function(term, begin_date, end_date, key, page = 1) {

    out <- GET("http://api.nytimes.com/svc/search/v2/articlesearch.json",
        query = list('q' = term,
                     'begin_date' = begin_date,
                     'end_date' = end_date,
                     'api-key' = key,
                     'page' = page))

    return(out)

}

#' Get response content
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @param page page number. The default value is 1.
#' @return a dataframe output
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @export
#'

get_content <- function(term, begin_date, end_date, key, page = 1) {

    message(glue("Scraping page {page}"))

    fromJSON(content(get_request(term, begin_date, end_date, key, page),
                     "text",
                encoding = "UTF-8"),
                simplifyDataFrame = TRUE, flatten = TRUE) %>% as.data.frame()

}

#' Extract responses from all pages
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @param page page number. The default value is 1.
#' @return a dataframe output
#' @importFrom purrr slowly
#' @importFrom purrr pmap_dfr
#' @importFrom purrr rate_delay
#' @importFrom glue glue
#' @export
#'

extract_all <- function(term, begin_date, end_date, key) {

    request <- GET("http://api.nytimes.com/svc/search/v2/articlesearch.json",
                   query = list('q' = term,
                                'begin_date' = begin_date,
                                'end_date' = end_date,
                                'api-key' = key))

    max_pages <- (round(content(request)$response$meta$hits[1] / 10) - 1)

    message(glue("The total number of pages is {max_pages}"))

    if (max_pages > 200) {
        warning("As of now, the maximum amount of pages the NYT API will return is 200. Consider scraping a smaller amount at a time by changing the date range.")
    }

    iter <- 0:max_pages

    arg_list <- list(rep(term, times = length(iter)),
                     rep(begin_date, times = length(iter)),
                     rep(end_date, times = length(iter)),
                     rep(key, times = length(iter)),
                     iter
                     )

    out <- pmap_dfr(arg_list, slowly(get_content,
                                     # 6 seconds sleep is the default requirement.
                                     rate = rate_delay(
                                         pause = 6,
                                         max_times = 4000)))

    return(out)

    }
