##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param clean_gd_gs
##' @param generation_time
##' @param incubation_period
##' @param reporting_delay
##' @param npi_dates
##' @return
##' @author Nicholas Tierney
##' @export
estimate_reff <- function(clean_gd_gs,
                          generation_time,
                          incubation_period,
                          reporting_delay,
                          npi_dates,
                          n_samples,
                          n_warmup,
                          n_cores,
                          n_chains) {
  
  # see https://www.mja.com.au/journal/2020/victorias-response-resurgence-covid-19-has-averted-9000-37000-cases-july-2020
  # dates of the major changes - Stage 3 + 4 restrictions on all of Melbourne:
  
  d2 <- clean_gd_gs %>%
    mutate(confirm = round(cases_corrected)) %>%
    select(date, confirm) %>%
    mutate(breakpoint = as.numeric(date %in% npi_dates)) %>%
    as.data.table()
  
  stopifnot(sum(d2$breakpoint) == length(npi_dates))
  
  estimates_vic <- EpiNow2::epinow(
    reported_cases = d2,
    generation_time = generation_time,
    delays = list(incubation_period, reporting_delay),
    horizon = 14,
    samples = n_samples,
    warmup = n_warmup,
    cores = n_cores,
    chains = n_chains,
    verbose = TRUE,
    adapt_delta = 0.95,
    estimate_breakpoints = TRUE
  )
  
  if (max(filter(estimates_vic$estimates$summarised, variable == "R")$top,
          na.rm = TRUE) > 10) {
    stop("Probable convergence problem; some estimates of R are implausibly high")
  }
  
  return(estimates_vic)
  

}
