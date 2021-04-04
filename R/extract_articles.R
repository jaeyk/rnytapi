
#' Form a request URL
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @return a request URL
#' @importFrom httr GET
#' @export
#'

get_request <- function(term, begin_date, end_date, key) {

    out <- GET("http://api.nytimes.com/svc/search/v2/articlesearch.json",
        query = list('q' = term,
                     'begin_date' = begin_date,
                     'end_date' = end_date,
                     'api-key' = key))

    return(out)

}

#' Get response content
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @return a dataframe output
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @export
#'

get_content <- function(term, begin_date, end_date, key) {

    fromJSON(content(get_request(term, begin_date, end_date, key),
                     "text",
                encoding = "UTF-8"),
                simplifyDataFrame = TRUE, flatten = TRUE)

}

#' Extract responses from a single page
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @return out the dataframe output of the NYT API response
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @export

extract_nyt_data <- function(term, begin_date, end_date, key){

    # JSON object
    out <- get_content(term, begin_date, end_date, key)

    return(out)

    }

#' Make the extracting function work slowly
#'
#' @param rate_limit The rate limit. The default limit is 7 seconds.
#' @importFrom purrr slowly
#' @importFrom purrr rate_delay
#' @export
#'

slowly_extract_nyt_data <- function(rate_limit = 6) {

    slowly(extract_nyt_data, rate = rate_delay(pause = rate_limit, max_times = 4000)) # 6 seconds sleep is the default requirement.

    }

#' Extract responses from all pages
#'
#' @param term search term
#' @param begin_date beginning date
#' @param end_date end date
#' @param key New York Times API key
#' @return a dataframe output
#' @importFrom purrr slowly
#' @importFrom purrr map_dfr
#' @export
#'

extract_all_nyt_data <- function(term, begin_date, end_date, key) {

    max_pages <- round((get_content(term, begin_date, end_date, key)$response$meta$hits[1] / 10) - 1)

    out <- map_dfr(0:max_pages, slowly_extract_nyt_data)

    return(out)

    }
