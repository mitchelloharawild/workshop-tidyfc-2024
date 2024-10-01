{
  lapply(list.files("data", full.names = TRUE), function(x) {
  assign(tools::file_path_sans_ext(basename(x)), readRDS(x), envir = .GlobalEnv)
  invisible()
  })
  cli::cat_boxx(
    "Welcome to the tidy forecasting workshop!",
  )
  cli::cli_alert_success("All workshop datasets have been loaded successfully!")
}
