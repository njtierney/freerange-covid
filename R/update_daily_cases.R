##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
update_daily_cases <- function() {

  covidlive_url <- "https://covidlive.com.au/report/daily-cases/vic"
  
  covidlive_raw <- covidlive_url %>% 
    bow() %>% 
    scrape() %>% 
    html_table() %>% 
    pluck(2) %>% 
    as_tibble()
  
  covidlive_raw %>% 
    mutate(DATE = strp_date(DATE),
           CASES = parse_number(CASES),
           NET = suppressWarnings(parse_number(NET))) %>% 
    clean_names() %>% 
    select(-var,
           -cases) %>% 
    rename(cases = net) %>% 
    select(date, cases) %>% 
  # need to alter negatives into 0 for the time being
    mutate(cases = if_else(cases < 0, 0, cases))
    

}
