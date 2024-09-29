# Set up chunk for all slides
knitr::opts_chunk$set(
  echo = TRUE,
  message = FALSE,
  warning = FALSE,
  cache = TRUE,
  dev.args = list(pointsize = 11)
)
options(
  digits = 3,
  width = 75,
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  ggplot2.discrete.colour = c("#D55E00", "#0072B2", "#009E73", "#CC79A7", "#E69F00", "#56B4E9", "#F0E442"),
  ggplot2.discrete.fill = c("#D55E00", "#0072B2", "#009E73", "#CC79A7", "#E69F00", "#56B4E9", "#F0E442")
)
lapply(list.files("exercises/data", full.names = TRUE), function(x) {
  assign(tools::file_path_sans_ext(basename(x)), readRDS(x), envir = .GlobalEnv)
  invisible()
})
library(fpp3)
library(patchwork)