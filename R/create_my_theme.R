##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

##' @return
##' @author Nicholas Tierney
##' @export
create_my_theme <- function(main_font,
                            heading_font) {

  theme_light(base_family = main_font) + 
    theme(legend.position = "bottom") +
    theme(plot.caption = element_text(colour = "grey50"),
          strip.text = element_text(size = rel(1), face = "bold"),
          plot.title = element_text(family = heading_font))

}
