library(readxl)
library(tsibble)

staff <- read_excel("data/schools/Table 50a In-school Staff (Number), 2006-2023.xlsx", sheet = 3, skip = 4) |> 
  as_tsibble(key = where(is.character), index = Year)

readr::write_rds(staff, "exercises/data/staff.rds")
