the_plan <-
  drake_plan(

    # where is victoria-daily-cases.csv updated?
    daily_cases = update_daily_cases(),
    # vic_dhhs = read_daily_cases(),
    gd_orig =  read_guardian_gs(),
    k = 0.1,
    myfont = "Roboto",
    main_font = "Roboto",
    heading_font = "Sarala",
    my_theme = create_my_theme(main_font, heading_font),
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
                         npi_dates,
                         n_samples = 10,
                         n_warmup = 10,
                         n_cores = 8,
                         n_chains = 4),
    create_pos_plot = positivity_plot(clean_gd_gs, k,
                                      vic_caption),
    create_pos_corrected_plot = positivity_corrected_plot(clean_gd_gs, 
                                                          k,
                                                          vic_caption),
    vic_caption = glue("Data from the DHHS; analysis by \\
                       http://freerangestats.info. Last updated {Sys.Date()}."),
    
    vic_results = bind_vic_estimates(reff),
    write_vic_results = write_csv(vic_results,
                                  glue("data/vic-results-{Sys.Date()}.csv")),
    pc_vic = my_plot_estimates(reff,
                               extra_title = " and positivity",
                               caption = vic_caption,
                               y_max = 1000,
                               my_theme = my_theme),
    cases = cases_plot(clean_gd_gs),
    save_pc_vic =  svg_png(pc_vic,
                           "imgs/victoria-latest",
                           h = 10,
                           w = 10),
    save_pos_plot = svg_png(create_pos_plot,
                            "imgs/victoria-positivity",
                            h = 5,
                            w = 9),
    save_pos_corrected_plot = svg_png(create_pos_corrected_plot,
                                      "imgs/victoria-positivity-correction",
                                      h = 5,
                                      w = 9),
    
    report = target(
      command = {
        rmarkdown::render(knitr_in("doc/figures.Rmd"))
        file_out("doc/figures.html")
      }
    )

)
