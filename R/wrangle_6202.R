library(tidyverse)
library(fpp3)

readxl::read_excel("data/6202_all_monthly_spreadsheets/6202001.xlsx")

readxl::excel_sheets("data/6202_all_monthly_spreadsheets/6202019.xlsx")

z <- readabs::read_abs("6202.0", "19")
z |> 
  filter(series_type == "Trend", series == "Monthly hours worked in all jobs ;  Persons ;") |> 
  ggplot(aes(x = date, y = value)) + 
  geom_line()

z |> count(series)

z |> 
  filter(series_type == "Trend", grepl("employed", series)) |> 
  ggplot(aes(x = date, y = value)) + 
  geom_line(aes(colour = series))
