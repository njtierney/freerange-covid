##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param clean_gd_gs
##' @return
##' @author Nicholas Tierney
##' @export
positivity_plot <- function(clean_gd_gs) {

  #-----------------Positivity plot------------------
  hp <- clean_gd_gs %>%
    filter(!is.na(ps1)) %>%
    filter(date == max(date))
  
  pos_line <- clean_gd_gs %>%
    ggplot(aes(x = date)) +
    geom_line(aes(y = ps1), colour = "steelblue") +
    geom_point(aes(y = pos_raw)) +
    geom_text(
      data = hp,
      aes(label = percent(ps1, accuracy = 0.1), y = ps1),
      hjust = 0,
      nudge_x = 1,
      colour = "steelblue"
    ) +
    scale_y_log10(label = percent_format(accuracy = 0.1)) +
    xlim(min(clean_gd_gs$date), hp$date + 3) +
    labs(
      x = "",
      y = "Test positivity (log scale)",
      caption = vic_caption,
      title = "Covid-19 test positivity in Victoria, Australia, 2020",
      subtitle = str_wrap(
        glue(
          "Smoothed line is from a generalized additive model,
       and is used to adjust incidence numbers before analysis to estimate effective reproduction number.
       The lowest rate is {percent(min(d$ps1), accuracy = 0.01)}, and a positivity rate of 1.5% would result in
       adjusted case numbers being {comma((0.015 / min(d$ps1)) ^ k, accuracy = 0.01)} times their raw value."
        ),
        110
      )
    )
  
  
  pos_line
  
}
