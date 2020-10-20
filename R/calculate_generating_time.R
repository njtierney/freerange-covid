##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
calculate_generating_time <- function() {

  generation_time <- list(
    mean = EpiNow2::covid_generation_times[1, ]$mean,
    mean_sd = EpiNow2::covid_generation_times[1, ]$mean_sd,
    sd = EpiNow2::covid_generation_times[1, ]$sd,
    sd_sd = EpiNow2::covid_generation_times[1, ]$sd_sd,
    max = 30
    )
  
  generation_time
}
