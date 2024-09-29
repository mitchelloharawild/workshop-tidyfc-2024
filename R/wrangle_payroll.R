payroll <- readabs::read_payrolls("industry_jobs")
payroll |> 
  filter(industry == "P-Education & training", state == "Australia", sex == "Persons", age == "All ages") |> 
  as_tsibble(index = date) |> 
  autoplot(value)

payroll_subindustry <- readabs::read_payrolls("subindustry_jobs")
payroll_subindustry |> 
  filter(industry_division == "P-Education & training") |> 
  as_tsibble(index = date, key = industry_subdivision) |> 
  autoplot(value)

library(tsibble)
library(readabs)
library(dplyr)
payroll_education <- read_payrolls("subindustry_jobs") |> 
  filter(industry_division == "P-Education & training") |> 
  transmute(Industry = industry_subdivision, Week = yearweek(date), Jobs = value) |> 
  as_tsibble(index = Week, key = Industry)
