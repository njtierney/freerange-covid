##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param estimate_reff
##' @return
##' @author Nicholas Tierney
##' @export
bind_vic_estimates <- function(reff) {

  
  # I don't think we need the "max" column, so let's delete it.
  # setdiff(names(reff$plots$infections$data),
  #         names(reff$plots$reff$data))
  
  pos_adjusted_cases <- reff$plots$reports$data %>% select(-max)
  infections <- reff$plots$infections$data %>% select(-max)
  effective_r <- reff$plots$reff$data 
  
  # then reorder the names of the variables so they are the same
  infect_names <- names(infections)
  
  vic_results <- bind_rows(
    "positivity-adjusted reported cases" = select(pos_adjusted_cases,
                                                  all_of(infect_names)),
    "Infections" = select(infections, 
                         all_of(infect_names)),
    "Effective reproduction number (R)" = select(effective_r, 
                                                 all_of(infect_names)),
    .id = "type"
  ) %>% 
    as_tibble()
  
  return(vic_results)

}

# this code broke with a data.table error:
# Error in lapply(list(...), function(x) if (is.list(x)) x else as.data.table(x)) : 
#   argument is missing, with no default

# vic_results <- rbind(
#   select(mutate(reff$plots$reports$data, 
#                 type = "positivity-adjusted reported cases"), -max),
#   select(mutate(reff$plots$infections$data, 
#                 type = "Infections"), -max),
#   mutate(reff$plots$reff$data,
#          type = "Effective reproduction number (R)"),
# ) %>%
#   as_tibble()