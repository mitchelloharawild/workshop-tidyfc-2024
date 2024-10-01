library(readxl)
library(dplyr)
library(tsibble)

students <- read_excel(
  "data-raw/Table 42b Number of Full-time and Part-time Students - 2006-2023.xlsx",
  sheet = 3, skip = 4
) |> 
  # Group by Year and all the character variables
  group_by(Year, across(where(is.character), ~ substring(., 3))) |> 
  # Add up the duplicate rows
  summarise(across(ends_with("count"), sum), .groups = "drop") |> 
  # Convert to a tsibble
  as_tsibble(
    key = where(is.character),
    index = Year
  )

readr::write_rds(students, "data/students.rds")
