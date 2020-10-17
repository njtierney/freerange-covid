##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param create_pos_corrected_plot
##' @return
##' @author Nicholas Tierney
##' @export
estimate_reff <- function(create_pos_corrected_plot) {

  #---------Estimate Reff-------------
  # see https://www.mja.com.au/journal/2020/victorias-response-resurgence-covid-19-has-averted-9000-37000-cases-july-2020
  # dates of the major changes - Stage 3 and Stage 4 restrictions on all of Melbourne:
  
  
  d2 <- d %>%
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
    samples = 3000,
    warmup = 600,
    cores = 4,
    chains = 4,
    verbose = TRUE,
    adapt_delta = 0.95,
    estimate_breakpoints = TRUE
  )
  
  
  if (max(filter(estimates_vic$estimates$summarised, variable == "R")$top,
          na.rm = TRUE) > 10) {
    stop("Probable convergence problem; some estimates of R are implausibly high")
  }
  
  pc_vic <- my_plot_estimates(
    estimates_vic,
    extra_title = " and positivity",
    caption = vic_caption,
    y_max = 1000
  )
  
  svg_png(pc_vic,
          "../img/covid-tracking/victoria-latest",
          h = 10,
          w = 10)
  
  svg_png(pc_vic,
          "../_site/img/covid-tracking/victoria-latest",
          h = 10,
          w = 10)
  
  vic_results <- rbind(
    mutate(estimates_vic$plots$reports$data, type = "positivity-adjusted reported cases"),
    mutate(estimates_vic$plots$infections$data, type = "Infections"),
    mutate(estimates_vic$plots$reff$data, type = "Effective reproduction number (R)")
  ) %>%
    as_tibble()
  write_csv(vic_results,
            glue("../covid-tracking/vic-results-{Sys.Date()}.csv"))
  write_csv(vic_results,
            glue("../_site/covid-tracking/vic-results-{Sys.Date()}.csv"))
  write_csv(vic_results,
            glue("../_site/covid-tracking/vic-results-latest.csv"))
  
  

}
