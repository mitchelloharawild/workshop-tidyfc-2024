library(tidyverse)
library(fpp3)
skill_vacancies <- readxl::read_excel("data/Internet Vacancies, ANZSCO Skill Level, States and Territories - May 2024.xlsx", sheet = 2) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies",
               names_transform = list(month = ~ yearmonth(as.Date(as.integer(.), origin = "1900-01-01")))) |> 
  # Remove aggregate vacancies
  filter(State != "AUST", Skill_level != 0) |> 
  # Convert to tsibble
  as_tsibble(key = c(State, Skill_level), index = month)

skill_vacancies |>
  aggregate_key(State, vacancies = sum(vacancies)) |> 
  autoplot(vacancies)

anzco_occupations <- readxl::read_excel("data/Internet Vacancies, ANZSCO2 Occupations, States and Territories - May 2024.xlsx", sheet = 1) |> 
  distinct(ANZSCO_CODE, Title)

occupation_vacancies <- readxl::read_excel("data/Internet Vacancies, ANZSCO2 Occupations, States and Territories - May 2024.xlsx", sheet = 1) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies",
               names_transform = list(month = ~ yearmonth(as.Date(as.integer(.), origin = "1900-01-01")))) |> 
  # Remove aggregate vacancies
  filter(nchar(ANZSCO_CODE) > 1, State == "AUST") |> 
  mutate(ANZSCO_CODE_CAT = substr(ANZSCO_CODE, 1, 1)) |> 
  left_join(anzco_occupations, by = c("ANZSCO_CODE_CAT" = "ANZSCO_CODE"), suffix = c("", "_CAT")) |> 
  # Convert to tsibble
  as_tsibble(key = c(Title_CAT, Title), index = month)



occupation_vacancies |> 
  group_by(Title_CAT) |> 
  summarise(vacancies = sum(vacancies)) |> 
  autoplot(vacancies)

# !!!
occupation_vacancies |> 
  filter(Title == "Education Professionals") |> 
  autoplot(vacancies)

group_calc <- function(x, .f, ...) {
  unlist(lapply(split(x, interaction(...)), .f), recursive = FALSE)
}

occupation_vacancies |> 
  filter(Title == "Education Professionals") |> 
  ggplot(aes(x = month, y = group_calc(vacancies, function(x) x/x[1], Title), group = Title)) + 
  geom_line(aes(group = Title), colour = "grey70", data = occupation_vacancies) + 
  geom_line(colour = "steelblue")

occupation_vacancies |> 
  autoplot(vacancies) + 
  guides(colour = FALSE)

readxl::read_excel("data/Internet Vacancies, ANZSCO Skill Level, States and Territories - May 2024.xlsx", sheet = 2) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies",
               names_transform = list(month = ~ yearmonth(as.Date(as.integer(.), origin = "1900-01-01")))) |> 
  # Remove aggregate vacancies
  filter(Skill_level == 0) |> 
  # Convert to tsibble
  as_tsibble(key = c(State, Skill_level), index = month) |> 
  autoplot(vacancies)



anzco4_occupations <- readxl::read_excel("data/Internet Vacancies, ANZSCO4 Occupations, States and Territories - August 2024.xlsx", sheet = 2) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies",
               names_transform = list(month = ~ yearmonth(as.Date(as.integer(.), origin = "1900-01-01"))),
               values_transform = ~ parse_number(., na = "."))

ANZSCO4_edu <- c(2411, 2412, 2413, 2414, 2415, 2421, 2422, 2491, 2492, 2493)
anzco4_occupations |> 
  filter(ANZSCO_CODE %in% !!ANZSCO4_edu, state == "AUST") |> 
  as_tsibble(key = c(ANZSCO_TITLE, state), index = month) |> 
  autoplot(vacancies)

occupation_vacancies <- readxl::read_excel("data/Internet Vacancies, ANZSCO2 Occupations, States and Territories - May 2024.xlsx", sheet = 1) |> 
  # Tidy into a long form
  pivot_longer(matches("\\d{5}"), names_to = "month", values_to = "vacancies",
               names_transform = list(month = ~ yearmonth(as.Date(as.integer(.), origin = "1900-01-01")))) |> 
  # Remove aggregate vacancies
  filter(nchar(ANZSCO_CODE) > 1, State == "AUST") |> 
  mutate(ANZSCO_CODE_CAT = substr(ANZSCO_CODE, 1, 1)) |> 
  left_join(anzco_occupations, by = c("ANZSCO_CODE_CAT" = "ANZSCO_CODE"), suffix = c("", "_CAT")) |> 
  # Convert to tsibble
  as_tsibble(key = c(Title_CAT, Title), index = month)

