zip(
  "slides.zip",
  list.files("materials", pattern = "\\.pdf$", full.names = TRUE),
  flags = "-j"
)

withr::with_dir(
  "exercises",
  zip(
    "../labs.zip",
    c(".Rprofile", list.files(".", full.names = TRUE, recursive = TRUE))
  )
)