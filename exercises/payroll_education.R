library(tsibble)
library(readabs)
library(dplyr)
payroll_education <- read_payrolls("subindustry_jobs") |> 
  # Focus on education
  filter(industry_division == "P-Education & training") |> 
  # Tidy variable names and time granularity
  transmute(Industry = industry_subdivision, Week = yearweek(date), Jobs = value) |> 
  # Convert to tsibble
  as_tsibble(index = Week, key = Industry)
readr::write_rds(payroll_education, "exercises/data/payroll_education.rds")
