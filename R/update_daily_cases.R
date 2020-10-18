##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
update_daily_cases <- function() {

  covidlive_raw <- covidlive_url %>% 
    bow() %>% 
    scrape() %>% 
    html_table() %>% 
    pluck(2) %>% 
    as_tibble()
  
  covidlive_raw %>% 
    mutate(DATE = strp_date(DATE),
           CASES = parse_number(CASES),
           NET = parse_number(NET)) %>% 
    select(-VAR) %>% 
    clean_names() %>% 
    rename(cases = net) %>% 
    select(date, cases)

}
