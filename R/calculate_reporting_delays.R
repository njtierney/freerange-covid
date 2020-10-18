##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
calculate_reporting_delays <- function() {

  #------------Reporting delays---------------------
  # From the documentation re delays: " (assuming a lognormal distribution with all 
  # parameters excepting the max allowed value on the log scale).
  
  
  if(!exists("reporting_delay") || 
     !exists("generation_time") ||
     !exists("incubation_period")){
    
    set.seed(123)
    
    reporting_delay <- EpiNow2::bootstrapped_dist_fit(rlnorm(100, log(6), 1))
    ## Set max allowed delay to 30 days to truncate computation
    reporting_delay$max <- 30
    
    generation_time <- list(mean = EpiNow2::covid_generation_times[1, ]$mean,
                            mean_sd = EpiNow2::covid_generation_times[1, ]$mean_sd,
                            sd = EpiNow2::covid_generation_times[1, ]$sd,
                            sd_sd = EpiNow2::covid_generation_times[1, ]$sd_sd,
                            max = 30)
    
    incubation_period <- list(
      mean = EpiNow2::covid_incubation_period[1, ]$mean,
      mean_sd = EpiNow2::covid_incubation_period[1, ]$mean_sd,
                              sd = EpiNow2::covid_incubation_period[1, ]$sd,
                              sd_sd = EpiNow2::covid_incubation_period[1, ]$sd_sd,
                              max = 30)
  }

}
