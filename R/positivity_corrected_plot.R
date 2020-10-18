##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param clean_gd_gs
##' @return
##' @author Nicholas Tierney
##' @export
positivity_corrected_plot <- function(clean_gd_gs) {

  #--------------------Positivity correction--------------
  pos_correction <- clean_gd_gs %>%
    select(date,
           `Confirmed` = confirm,
           `Positivity-corrected` = cases_corrected) %>%
    gather(variable, value, -date) %>%
    ggplot(aes(x = date, y = value, colour = variable)) +
    geom_point() +
    geom_smooth(se = FALSE,
                method = "loess",
                span = 1 / 10) +
    scale_y_continuous(label = comma) +
    labs(
      x = "",
      y = "Number of cases",
      colour = "",
      title = "Confirmed cases compared to positivity correction",
      subtitle = glue("With a positivity-correction parameter of k={k}"),
      caption = vic_caption
    ) +
    scale_colour_brewer(palette = "Set1")
  
  pos_correction
  
}
