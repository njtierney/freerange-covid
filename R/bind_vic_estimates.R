##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param estimate_reff
##' @return
##' @author Nicholas Tierney
##' @export
bind_vic_estimates <- function(estimate_reff) {

  vic_results <- rbind(
    mutate(estimates_vic$plots$reports$data, 
           type = "positivity-adjusted reported cases"),
    mutate(estimates_vic$plots$infections$data, 
           type = "Infections"),
    mutate(estimates_vic$plots$reff$data, 
           type = "Effective reproduction number (R)")
  ) %>%
    as_tibble()
  
  return(vic_results)

}
