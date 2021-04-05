library(testthat)
library(rnytapi)

get_request(term = "muslim+muslims",
            begin_date = "19960911",
            end_date = "20060911",
            key = "<insert your key>")

get_content(term = "muslim+muslims",
            begin_date = "19960911",
            end_date = "20060911",
            key = "<insert your key>")

slowly_extract(term = "muslim+muslims",
               begin_date = "19960911",
               end_date = "20060911",
               key = "<insert your key>")

extract_all(term = "muslim+muslims",
            begin_date = "19960911",
            end_date = "20060911",
            key = "<insert your key>")
