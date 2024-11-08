library(fpp3)
staff |> 
  # Comparing across which variable?
  group_by(`State/Territory`) |> 
  # Calculate total staff
  summarise(total = sum(`In-School Staff Count`)) |> 
  # Only care about 2022
  filter(Year == 2022) |> 
  # Sort by total staff
  arrange(desc(total)) |> 
  ggplot(aes(x = `State/Territory`, y = total)) +
  geom_col()

staff |> 
  # Comparing across which variable?
  group_by(`State/Territory`, `Affiliation 2`) |> 
  # Calculate total staff
  summarise(total = sum(`In-School Staff Count`))

staff |> 
  group_by(Sex) |> 
  summarise(total = sum(`In-School Staff Count`)) |> 
  ggplot(aes(x = Year, y = total)) + 
  geom_line(aes(colour = Sex))


students |> 
  summarise(total = sum(`All Full-time and Part-time Student count`)) |> 
  autoplot(total)

students |> 
  group_by(`State/Territory`) |> 
  summarise(total = sum(`All Full-time and Part-time Student count`)) |> 
  autoplot(total) + 
  scale_y_log10()

students |> 
  group_by(`State/Territory`) |> 
  summarise(total = sum(`All Full-time and Part-time Student count`)) |> 
  ggplot(aes(x = Year, y = total, 
             colour = `State/Territory`)) + 
  geom_line() + 
  labs(
    y = "Total students",
    title = "Total students by state over time"
  ) + 
# Coming soon? or in the deep depths of your sharepoint drive?
# theme_deptedu()
  theme_minimal()

# QUESTION: autoplot() for data frames
plot(mtcars)

vic_elec |> 
  autoplot(Demand)
vic_elec |> 
  gg_season(Demand)
vic_elec |> 
  gg_season(Demand, period = "year")
vic_elec |> 
  gg_season(Demand, period = "week")
vic_elec |> 
  gg_season(Demand, period = "day")


student_labour |> 
  summarise(persons = sum(persons)) |> 
  autoplot()

student_labour |> 
  summarise(persons = sum(persons)) |> 
  gg_season()
student_labour |> 
  summarise(persons = sum(persons)) |> 
  gg_subseries()

aus_production |> 
  ACF(Beer) |> 
  autoplot()


students |> 
  summarise(total = sum(`All Full-time and Part-time Student count`)) |> 
  ACF(total) |> 
  autoplot()

student_labour |> 
  distinct(state)
student_labour |> 
  distinct(status)
student_labour |> 
  distinct(attendance)
working_students <- student_labour |> 
  filter(
    state == "Australian Capital Territory",
    status != "Not in the labour force (NILF)",
    attendance != "Not attending full-time education"
  ) |> 
  summarise(persons = sum(persons))
working_students |> 
  autoplot(persons)
working_students |> 
  ACF(persons) |> 
  autoplot()



student_labour |> 
  summarise(persons = sum(persons)) |>
  model(STL(persons)) |> 
  components() |> 
  gg_subseries(season_year)

global_economy |> 
  filter(Code == "AUS") |> 
  autoplot(GDP/Population)
global_economy |> 
  filter(Country == "Afghanistan") |> 
  autoplot(GDP/Population)

global_economy |> 
  autoplot(GDP) + 
  guides(colour = FALSE)


global_economy |> 
  autoplot(GDP/Population) + 
  guides(colour = FALSE) + 
  scale_y_log10()

max_gdp <- global_economy |> 
  filter(Year == 2016) |> 
  slice_max(GDP/Population, n = 5)

  # filter(GDP/Population == max(GDP/Population, na.rm = TRUE))

# global_economy |> 
#   filter(Country == "World")

max_gdp_ts <- global_economy |> 
  semi_join(max_gdp, by = "Country")

global_economy |> 
  # filter(Code %in% c("AUS", "USA")) |> 
  ggplot(aes(x = Year, y = GDP/Population, 
             group = Country)) + 
  geom_line(alpha = 0.2) + 
  geom_line(aes(colour = Country), data = max_gdp_ts) + 
  theme_minimal() + 
  scale_y_log10()


aus_production |> 
  autoplot(box_cox(Beer, guerrero(Beer)))

aus_production |> 
  autoplot(box_cox(Beer, 0))

aus_production |> 
  features(Beer, guerrero)

canadian_gas |> 
  autoplot()
canadian_gas |> 
  autoplot(log(Volume))
canadian_gas |> 
  autoplot(box_cox(Volume, 1.8))


student_labour |> 
  summarise(persons = sum(persons)) |> 
  model(STL(persons)) |> 
  components() |> 
  gg_subseries(season_year)


canadian_gas |> 
  model(STL(Volume ~ season(window = 11) + trend(window = 27))) |> 
  components() |> 
  autoplot()

canadian_gas |> 
  model(STL(Volume ~ season(window = 11) + trend(window = 27))) |> 
  components() |> 
  gg_subseries(season_year)


brick_fit <- aus_production |>
  filter(!is.na(Bricks)) |>
  model(
    `Seasonal_naive` = SNAIVE(Bricks),
    `Naive` = NAIVE(Bricks),
    Drift = RW(Bricks ~ drift()),
    Mean = MEAN(Bricks)
  )

brick_fit |> 
  select(Drift) |> 
  forecast(h = "10 years") |> 
  autoplot(aus_production)

brick_fit |> 
  select(Mean) |> 
  forecast(h = "10 years") |> 
  autoplot(aus_production)

brick_fit |> 
  select(Naive) |> 
  forecast(h = "10 years") |> 
  autoplot(aus_production)

brick_fit |> 
  select(Seasonal_naive) |> 
  forecast(h = "10 years") |> 
  autoplot(aus_production)
  
brick_fit |> 
  # select(Seasonal_naive) |> 
  forecast(h = "10 years") |> 
  autoplot(
    tail(aus_production, 80), 
    alpha = 0.2,
    level = 50
  )


brick_fit |> 
  forecast(h = "10 years") |> 
  hilo(level = 50) #|> 
  # select(-Bricks)


# Lab session 1

# Data 1 (total school staff)
total_staff <- staff |> 
  summarise(staff = sum(`In-School Staff Count`))
total_staff |> 
  autoplot(staff)
total_staff |> 
  model(
    # NAIVE(staff)
    # SNAIVE(staff)
    # MEAN(staff)
    RW(staff ~ drift())
  ) |> 
  forecast(h = "5 years") |> 
  autoplot(total_staff)

# Data 2 (School education jobs)
payroll_education |> 
  distinct(Industry)
school_edu <- payroll_education |> 
  filter(Industry == "Preschool and School Education") |> 
  summarise(Jobs = sum(Jobs))
school_edu |> 
  autoplot(Jobs)
school_edu |> 
  model(
    RW(Jobs ~ drift()),
    SNAIVE(Jobs)
  ) |> 
  forecast(h = "2 years") |> 
  autoplot(school_edu)

# Data 3
total_retail <- aus_retail |> 
  summarise(Turnover = sum(Turnover))
total_retail |> 
  autoplot(Turnover)

total_retail |> 
  model(
    RW(Turnover ~ drift()),
    SNAIVE(Turnover)
  ) |> 
  forecast(h = "5 years") |> 
  autoplot(total_retail)
