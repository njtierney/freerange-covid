##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param daily_cases
##' @param gd_orig
##' @return
##' @author Nicholas Tierney
##' @export
clean_guardian_gs <- function(daily_cases, gd_orig) {

  
  k <- 0.1
  
  if (max(daily_cases$date) < (Sys.Date() - 1)) {
    warning("No data yet for yesterday")
  }
  
  d <- gd_orig %>%
    clean_names() %>%
    filter(state == "VIC") %>%
    # deal with problem of multiple observations some days:
    mutate(date = as.Date(date)) %>%
    group_by(date) %>%
    summarise(tests_conducted_total = max(tests_conducted_total, na.rm = TRUE)) %>%
    mutate(tests_conducted_total  = ifelse(tests_conducted_total < 0, NA, tests_conducted_total)) %>%
    ungroup() %>%
    # correct one typo, missing a zero
    mutate(tests_conducted_total = ifelse(date == as.Date("2020-07-10"), 1068000, tests_conducted_total)) %>%
    # correct another typo or otherwise bad data point
    mutate(tests_conducted_total = ifelse(date == as.Date("2020-08-08"), NA, tests_conducted_total)) %>%
    # remove two bad dates
    filter(!date %in% as.Date(c("2020-06-06", "2020-06-07"))) %>%
    mutate(date = date - 1) %>%
    full_join(daily_cases, by = "date") %>%
    rename(confirm = cases) %>%
    mutate(
      test_increase = c(tests_conducted_total[1], diff(tests_conducted_total)),
      pos_raw = pmin(1, confirm / test_increase)
    ) %>%
    complete(date = seq.Date(min(date), max(date), by = "day"),
             fill = list(confirm = 0)) %>%
    mutate(numeric_date = as.numeric(date),
           positivity = pos_raw) %>%
    filter(date > as.Date("2020-05-01")) %>%
    fill(positivity, .direction = "downup") %>%
    mutate(
      ps1 = fitted(gam(
        positivity ~ s(numeric_date),
        data = .,
        family = "quasibinomial"
      )),
      ps2 = fitted(loess(
        positivity ~ numeric_date, data = ., span = 0.1
      )),
      cases_corrected = confirm * ps1 ^ k / min(ps1 ^ k)
    ) %>%
    ungroup() %>%
    mutate(
      smoothed_confirm = fitted(loess(
        confirm ~ numeric_date, data = ., span = 0.1
      )),
      seven_day_avg_confirm = zoo::rollapplyr(confirm, width = 7, mean, na.pad = TRUE)
    )
  
  if (max(count(d, date)$n) > 1) {
    tail(d)
    stop("Some duplicate days, usually coming from partial data")
  }
  
  if (max(d$date) < (Sys.Date() - 1)) {
    stop("No data yet for yesterday")
  }
  
  if (!(Sys.Date() - 2) %in% d$date) {
    stop("No data for day before yesterday")
  }
  
  return(d)
  

}
