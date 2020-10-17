##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
read_daily_cases <- function() {

  read_csv("victoria-daily-cases.csv", 
           col_types = c("cd")) %>%
    mutate(date = as.Date(date, format = "%B %d, %Y"))

}
