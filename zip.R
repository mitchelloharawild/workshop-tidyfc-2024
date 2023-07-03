zip(
  "slides.zip",
  list.files("materials/", pattern = "\\.pdf$", full.names = TRUE),
  flags = "-j"
)

# zip(
#   "labs.zip",
#   list.files("_site/labs/", pattern = "\\.r$", full.names = TRUE),
#   flags = "-j"
# )

