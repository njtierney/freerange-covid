##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
calculate_incubation_period <- function() {

  incubation_period <- list(
    mean = EpiNow2::covid_incubation_period[1, ]$mean,
    mean_sd = EpiNow2::covid_incubation_period[1, ]$mean_sd,
    sd = EpiNow2::covid_incubation_period[1, ]$sd,
    sd_sd = EpiNow2::covid_incubation_period[1, ]$sd_sd,
    max = 30
    )
  
  incubation_period

}
