library(readxl)
library(dplyr)
library(tsibble)

staff <- read_excel("data-raw/Table 50a In-school Staff (Number), 2006-2023.xlsx", sheet = 3, skip = 4) |> 
  mutate(across(where(is.character), ~ substring(., 3))) |> 
  as_tsibble(key = where(is.character), index = Year)

readr::write_rds(staff, "data/staff.rds")
