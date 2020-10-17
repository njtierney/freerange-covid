the_plan <-
  drake_plan(

    # where is victoria-daily-cases.csv updated?
    update_daily_cases = update_daily_cases(),
    vic_dhhs = read_daily_cases(),
    gd_orig =  read_guardian_gs(),
    reporting_delays = calculate_reporting_delays(),
    clean_gd_gs = clean_guardian_gs(vic_dhhs, gd_orig),
    create_pos_plot = positivity_plot(clean_gd_gs),
    create_pos_corrected_plot = positivity_corrected_plot(clean_gd_gs),
    estimate_reff = estimate_reff(clean_gd_gs),
    cases = cases_plot(clean_gd_gs)
    
    
    

)
