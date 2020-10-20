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
    set.seed(123)
    
    reporting_delay <- EpiNow2::bootstrapped_dist_fit(rlnorm(100, log(6), 1))
    ## Set max allowed delay to 30 days to truncate computation
    reporting_delay$max <- 30
    
    reporting_delay
    

}
