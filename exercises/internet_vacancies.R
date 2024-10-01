library(readxl)
library(dplyr)
library(tidyr)
library(tsibble)

anzsco_categories <- read_excel("data-raw/Internet Vacancies, ANZSCO2 Occupations, States and Territories - August 2024.xlsx", sheet = 1) |> 
  filter(Level == 2) |> 
  distinct(ANZSCO_CODE, Title)

internet_vacancies <- read_excel("data-raw/Internet Vacancies, ANZSCO2 Occupations, States and Territories - August 2024.xlsx", sheet = 1) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies") |> 
  mutate(month = yearmonth(as.Date(as.integer(month), origin = "1900-01-01"))) |> 
  # Remove aggregates
  filter(Level == 3, State != "AUST") |> 
  # Add level 2 category information
  mutate(ANZSCO_CODE_CAT = substr(ANZSCO_CODE, 1, 1)) |> 
  left_join(anzsco_categories, by = c("ANZSCO_CODE_CAT" = "ANZSCO_CODE"), suffix = c("", "_CAT")) |> 
  select(ANZSCO_CODE, Title_CAT, Title, State, month, vacancies) |> 
  # Convert to a tsibble
  as_tsibble(
    key = c(Title_CAT, Title, State),
    index = month
  )

readr::write_rds(internet_vacancies, "data/internet_vacancies.rds")
