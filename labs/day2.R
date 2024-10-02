library(fpp3)

students_total <- students |> 
  summarise(enrolments = sum(`All Full-time and Part-time Student count`))

students_total |> 
  autoplot(enrolments)

fit <- students_total |> 
  model(
    drift = RW(enrolments ~ drift())
  )

fit |> 
  forecast(h = 10) |> 
  autoplot(students_total)

fit |> 
  gg_tsresiduals()

augment(fit) |> 
  ggplot(aes(x = .innov)) +
  geom_histogram(bins = 7)

augment(fit) |> 
  features(.innov, ljung_box, 6)



fit <- students_total |> 
  model(
    drift = MEAN(enrolments)
  )

fit |> 
  forecast(h = 10) |> 
  autoplot(students_total)

fit |> 
  gg_tsresiduals()

augment(fit) |> 
  ggplot(aes(x = .innov)) +
  geom_histogram(bins = 7)

augment(fit) |> 
  features(.innov, ljung_box, 6)


as_tsibble(USAccDeaths) |> 
  model(MEAN(value)) |> 
  gg_tsresiduals()
as_tsibble(USAccDeaths) |> 
  model(MEAN(value)) |> 
  augment() |> 
  gg_season(.innov)

aus_train <- aus_production |> 
  filter(year(Quarter) <= 2007)

aus_production |> 
  autoplot(Beer) + 
  autolayer(aus_train, Beer, colour = "red")

aus_train |> 
  model(
    SNAIVE(Beer)
  ) |> 
  forecast(h = "2 years") |> 
  autoplot(aus_production |> 
             filter(year(Quarter) >= 2000))

# In-sample (fitted values) accuracy
aus_train |> 
  model(
    SNAIVE(Beer),
    MEAN(Beer)
  ) |> 
  accuracy()

# Out-of-sample (forecast values) accuracy
aus_train |> 
  model(
    SNAIVE(Beer),
    MEAN(Beer)
  ) |> 
  forecast(h = "2 years") |> 
  accuracy(aus_production)


# Lab session 11
student_labour |> 
  distinct(attendance)
student_labour |> 
  distinct(status)
working_students <- student_labour |> 
  filter(
    attendance != "Not attending full-time education",
    status != "Not in the labour force (NILF)"
  ) |> 
  summarise(persons = sum(persons))

# Plot the data
working_students |> 
  autoplot(persons)

max(working_students$month)

# Model the data
fit <- working_students |> 
  filter(
    month <= yearmonth("2020 Aug")
  ) |> 
  model(
    drift = RW(persons ~ drift()),
    snaive = SNAIVE(persons)
  )
  
# In-sample (1-step) fitted accuracy
fit |> 
  accuracy()

# Out-of-sample (h-step) forecast accuracy
fit |> 
  forecast(h = "4 years") |> 
  accuracy(working_students)

# ┌──────────────────────┐
# │                      │
# │   Cross-validation   │
# │                      │
# └──────────────────────┘

working_students |> 
  stretch_tsibble(.step = 2*12, .init = 10*12) |> 
  mutate(.id = -.id) |> 
  autoplot()

# Model the data
fit <- working_students |> 
  # Training set creation
  # filter(
  #   month <= yearmonth("2020 Aug")
  # ) |> 
  
  # Cross-validation creation
  stretch_tsibble(.step = 2*12, .init = 10*12) |> 
  model(
    drift = RW(persons ~ drift()),
    snaive = SNAIVE(persons)
  )

# In-sample (1-step) fitted accuracy
fit |> 
  accuracy()

# Out-of-sample (h-step) forecast accuracy
fit |> 
  forecast(h = "4 years") |> 
  accuracy(working_students)



## ETS

aus_economy <- global_economy |> 
  filter(Country == "Australia")

aus_economy |> 
  autoplot(Population)

fit <- aus_economy |> 
  model(
    aan = ETS(Population ~ error("A") + trend("A") + season("N")),
    aadn = ETS(Population ~ error("A") + trend("Ad") + season("N")),
    drift = RW(Population ~ drift())
  )

report(fit)

fit |> 
  forecast(h = "20 years") |> 
  autoplot(aus_economy, level = 50, alpha = 0.5)


fit |> 
  select(aan) |> 
  components() |> 
  autoplot()


fit <- global_economy |> 
  model(ETS(Population))

fit |> 
  print(n=100)

fit |> 
  forecast(h = "20 years")


# Lab session 12


aus_economy |> 
  autoplot(GDP)
aus_economy |> 
  autoplot(log(GDP))
aus_economy |> 
  autoplot(box_cox(GDP, guerrero(GDP)))


fit <- aus_economy |> 
  model(
    mmn = ETS(GDP ~ error("M") + trend("M") + season("N")),
    aan = ETS(log(GDP) ~ error("A") + trend("A") + season("N")),
    auto = ETS(GDP)
  )

fit

fit |> 
  forecast(h = "20 years", times = 1000) |> 
  autoplot(aus_economy, 
           level = 50, alpha = 0.8) + 
  theme_minimal()


fit |> 
  select(aan) |> 
  components() |> 
  autoplot()


fit <- global_economy |> 
  model(ETS(GDP))

fit |> 
  print(n=100)

fit |> 
  forecast(h = "20 years")



# Seasonal ETS

tourism_holiday <- tourism |> 
  filter(Purpose == "Holiday")
tourism_holiday |> 
  summarise(Trips = sum(Trips)) |> 
  autoplot(Trips)
tourism_holiday |> 
  summarise(Trips = sum(Trips)) |> 
  model(
    nick = ETS(Trips ~ error(c("A", "M")) + trend(c("N")) +
                season("M")),
    mitch = ETS(Trips ~ error(c("A", "M")) + trend(c("A")) +
                season(c("M")))
  ) |> 
  glance()


tourism_holiday |> 
  summarise(Trips = sum(Trips)) |> 
  model(
    nick = ETS(Trips ~ error(c("A", "M")) + trend(c("N")) +
                 season("M")),
    mitch = ETS(Trips ~ error(c("A", "M")) + trend(c("A")) +
                  season(c("M")))
  ) |>
  tidy()

tourism_holiday |> 
  model(ETS(Trips))



tourism_holiday |> 
  # summarise(Trips = sum(Trips)) |> 
  model(ETS(Trips ~ trend("A"), ic = "bic")) |> 
  components() |> 
  autoplot() + 
  guides(colour = "none")

# State space models
# Dynamic linear models (regression with dynamic coefficients)



tourism_holiday |> 
  summarise(Trips = sum(Trips)) |>
  model(ETS(Trips)) |> 
  gg_tsresiduals()

# not looking normal


tourism_holiday |> 
  summarise(Trips = sum(Trips)) |>
  model(ETS(Trips)) |> 
  forecast(bootstrap = TRUE, times = 10) |> 
  autoplot(tourism_holiday|> 
             summarise(Trips = sum(Trips)) )


aus_economy <- global_economy |> 
  filter(Country == "Australia")
aus_economy |> 
  autoplot(Population)
aus_economy |> 
  model(
    ARIMA(Population), 
    ETS(Population)
  ) |> 
  forecast(h = "10 years") |> 
  autoplot(aus_economy, level = NULL)


enrolment_affiliation <- students |>
  group_by(`Affiliation (Gov/Cath/Ind)`) |>
  summarise(enrolments = sum(`All Full-time and Part-time Student count`))

# Check for transformations
# Also use difference() to find stationary data
enrolment_affiliation |> 
  # BUG REPORT?
  autoplot(difference(enrolments)) + 
  facet_grid(vars(`Affiliation (Gov/Cath/Ind)`), 
             scales = "free_y")


fit <- enrolment_affiliation |> 
  model(
    arima = ARIMA(enrolments ~ 1 + pdq(0:10, 1, 0:5)),
    ets = ETS(enrolments)
  )

fit |> 
  select(ets) |> 
  filter(`Affiliation (Gov/Cath/Ind)` == "Government") |> 
  gg_tsresiduals()

fit |> 
  forecast(h = "10 years") |> 
  autoplot(enrolment_affiliation)


## Lab session 15

youth_learning <- student_labour |>
  group_by(attendance) |>
  summarise(persons = sum(persons))


youth_learning |>
  # filter(attendance == "Attending full-time education") |> 
  autoplot(difference(persons, lag = 12)) + 
  # xlim(as.Date(c(yearmonth("1990 Jan"), yearmonth("2020 Jan")))) +
  guides(colour = "none")

youth_learning |>
  model(
    ARIMA(persons),
    ETS(persons)
  ) |> 
  forecast(h = "10 years") |> 
  autoplot(youth_learning)


payroll_education |>
  filter(Industry == "Preschool and School Education") |> 
  autoplot(Jobs)
fit <- payroll_education |>
  filter(Industry == "Preschool and School Education") |> 
  model(
    # trend(), season(), fourier(K = ???)
    ARIMA(Jobs ~ trend() + fourier(K = 10) + PDQ(0,0,0))
  )
report(fit)
augment(fit) |> 
  autoplot(.fitted) + 
  geom_line(aes(y = Jobs), colour = "steelblue")

gg_tsresiduals(fit)

fit |> 
  forecast(h = "3 years") |> 
  autoplot(payroll_education)

report(fit)



working_age_school_students <- student_labour |>
  filter(attendance == "Attending school (aged 15-19 years)") |>
  summarise(persons = sum(persons))
working_age_school_students |> autoplot(persons)

fit_policy <- working_age_school_students |>
  mutate(new_policy = month >= yearmonth("2013 Jan")) |>
  model(ARIMA(persons ~ new_policy*fourier(K = 3) + PDQ(0,0,0)))
report(fit_policy)

augment(fit_policy) |> 
  autoplot(.fitted) + 
  geom_line(aes(y = persons), colour = "steelblue")

future_policy <- new_data(working_age_school_students, 120) |>
  mutate(new_policy = year(month) <= 2030)
fit_policy |>
  forecast(future_policy) |> 
  autoplot(working_age_school_students)



aus_economy <- global_economy |> 
  filter(Country == "Australia")
fit <- aus_economy |> 
  model(
    VAR(vars(Imports, Exports) ~ AR(0:5))
  )
fit |> 
  forecast(h = "10 years") |> 
  autoplot(aus_economy)


global_economy |>
  filter(Country == "Australia") |>
  model(vecm = VECM(vars(Imports, Exports) ~ 1 + AR(p = 9), r = 1)) |>
  forecast(h = "10 years") |>
  autoplot(global_economy)

aus_economy |> 
  autoplot(vars(Growth, Imports))

aus_economy |>
  filter(!is.na(Growth)) |>
  model(varima = VARIMA(vars(Growth, Imports))) |>
  report()


aus_economy |>
  filter(!is.na(Growth)) |>
  model(varima = VARIMA(vars(Growth, Imports))) |>
  forecast(h = "10 years") |> 
  autoplot(aus_economy)


staff_affiliation <- staff |> 
  group_by(`Affiliation 2`) |> 
  summarise(Count = sum(`In-School Staff Count`)) |> 
  pivot_wider(names_from = `Affiliation 2`, values_from = Count)

staff_affiliation |> 
  autoplot(vars(Catholic, Government, Independent))

?tsDyn::Canada

library(MTS)
plot(vars::Canada)

with(
  staff_affiliation, 
  cointegration_johansen(cbind(Catholic, Government, Independent))
)

fit <- staff_affiliation |> 
  model(
    VECM(vars(Catholic, Government, Independent) ~ AR(1), r = 2)
  )

fit |> 
  IRF(h = "10 years", impulse = "Independent") |> 
  gg_irf()

fit |> 
  forecast(h = "10 years") |> 
  autoplot(staff_affiliation)

## Reconciliation

tourism |> 
  model(ETS(Trips))

tourism |> 
  aggregate_key(Purpose * (State / Region)) |> 
  key_data()


tourism_agg <- tourism |>
  aggregate_key(Purpose * (State / Region),
                Trips = sum(Trips)
  )
fc <- tourism_agg |>
  filter(Quarter < yearquarter("2016 Q1")) |>
  model(ets = ETS(Trips)) |>
  reconcile(ets_adjusted = min_trace(ets)) |>
  forecast(h = "2 years")

fc |> 
  accuracy(tourism_agg)

students_agg <- students |> 
  aggregate_key(
    # *: grouped (interacted), /: hierarchical (nested)
    `State/Territory` * `Affiliation (Gov/Cath/Ind)` * `School Level` * Sex * `Year (Grade)`,
    enrolments = sum(`All Full-time and Part-time Student count`)
  )

students_agg |> 
  key_data() |> 
  print(n=200)

students_fc <- students_agg |> 
  # Create training set
  filter(
    Year < 2020
  ) |> 
  # Produce base forecasts
  model(
    ets = ETS(enrolments)
  ) |> 
  reconcile(min_trace(ets)) |> 
  forecast(h = "4 years")

students_fc |> 
  accuracy(students_agg) |>
  group_by(.model) |> 
  # summarise(MASE = mean(MASE))
  summarise(across(where(is.numeric), mean))
