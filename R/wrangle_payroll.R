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
