the_plan <-
  drake_plan(

    # where is victoria-daily-cases.csv updated?
    daily_cases = update_daily_cases(),
    # vic_dhhs = read_daily_cases(),
    gd_orig =  read_guardian_gs(),
    k = 0.1,
    clean_gd_gs = clean_guardian_gs(daily_cases, gd_orig, k),
    reporting_delay = calculate_reporting_delays(),
    generation_time = calculate_generating_time(),
    incubation_period = calculate_incubation_period(),
    # non-pharmaceutical interventions: stage 4, masks, stage 3, 
    # stage 3 (selected suburbs)
    npi_dates = as.Date(
      c("2020/08/03", "2020/07/22", "2020/07/10", "2020/07/01")
      ),
    reff = estimate_reff(clean_gd_gs,
                        generation_time,
                        incubation_period,
                        reporting_delay,
                        npi_dates),
    create_pos_plot = positivity_plot(clean_gd_gs, k,
                                      vic_caption),
    save_pos_plot = svg_png(create_pos_plot,
                            "imgs/victoria-positivity",
                            h = 5,
                            w = 9),
    create_pos_corrected_plot = positivity_corrected_plot(clean_gd_gs, 
                                                          k,
                                                          vic_caption),
    save_pos_corrected_plot = svg_png(create_pos_corrected_plot,
                                      "imgs/victoria-positivity-correction",
                                      h = 5,
                                      w = 9),
    vic_caption = glue("Data from the DHHS; analysis by \\
                       http://freerangestats.info. Last updated {Sys.Date()}."),
    
    vic_results = bind_vic_estimates(reff),
    write_vic_results = write_csv(vic_results,
                                  glue("data/vic-results-{Sys.Date()}.csv")),
    pc_vic = my_plot_estimates(reff,
                               extra_title = " and positivity",
                               caption = vic_caption,
                               y_max = 1000),
    save_pc_vic =  svg_png(pc_vic,
                           "imgs/victoria-latest",
                           h = 10,
                           w = 10),
    cases = cases_plot(clean_gd_gs)
    

)
