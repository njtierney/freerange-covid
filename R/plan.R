the_plan <-
  drake_plan(

    # where is victoria-daily-cases.csv updated?
    daily_cases = update_daily_cases(),
    # vic_dhhs = read_daily_cases(),
    gd_orig =  read_guardian_gs(),
    reporting_delays = calculate_reporting_delays(),
    clean_gd_gs = clean_guardian_gs(daily_cases, gd_orig),
    create_pos_plot = positivity_plot(clean_gd_gs),
    save_pos_plot = svg_png(create_pos_plot,
                            "imgs/victoria-positivity",
                            h = 5,
                            w = 9),
    create_pos_corrected_plot = positivity_corrected_plot(clean_gd_gs),
    save_pos_corrected_plot = svg_png(create_pos_corrected_plot,
                                      "imgs/victoria-positivity-correction",
                                      h = 5,
                                      w = 9),
    vic_caption = glue("Data from the DHHS; analysis by \\
                       http://freerangestats.info. Last updated {Sys.Date()}."),
    estimate_reff = estimate_reff(clean_gd_gs),
    vic_results = bind_vic_estimates(estimate_reff),
    write_vic_results = write_csv(vic_results,
                                  glue("data/vic-results-{Sys.Date()}.csv")),
    pc_vic = my_plot_estimates(estimate_reff,
                               extra_title = " and positivity",
                               caption = vic_caption,
                               y_max = 1000),
    save_pc_vic =  svg_png(pc_vic,
                           "imgs/victoria-latest",
                           h = 10,
                           w = 10),
    cases = cases_plot(clean_gd_gs)
    

)
