# rnytapi

R interface for the New York Times API

<!-- badges: start -->
<!-- badges: end -->

The goal of `rnytapi` is to provide easy and fast tools to access and collect data using the New York Times API.

## Installation

``` r

## Install the current development version from GitHub

if(!require(devtools)) install.packages("devtools")

devtools::install_github("jaeyk/rnytapi", dependencies = TRUE)

```

## Example

The package's current main use case is to collect the NYT articles on a particular subject published during a specific period.

A single page output from the search. The default page is the first page. You can overwrite it by passing a new value for the `page` argument.

```r
library(rnytapi)

df <- get_content(term = "muslim+muslims",
            begin_date = "19960911",
            end_date = "20060911",
            key = "<insert your key>")
``` 

All results from the search. The function sleeps 6 seconds between calls to respect [the NYT API call limit](https://developer.nytimes.com/faq). Depending on the scope of the search, getting the results will take a substantial amount of time. 

```r
library(rnytapi)

df <- extract_all(term = "muslim+muslims",
            begin_date = "19960911",
            end_date = "20060911",
            key = "<insert your key>")
```
