library(readabs)
library(dplyr)
# Quarterly hours worked in all jobs by Market and Non-market sector
sector_hours <- read_abs("6202.0", tables = "21") |> 
  transmute(month = yearmonth(date), series, series_id, table_title, value)
sector_hours |> 
  as_tsibble(index = month, key = series) |> 
  autoplot(value)

read_abs(series_id = "A84426293X")

aus_students <- read_abs("6202.0", tables = "16") |> 
  filter(series_type == "Original", data_type == "STOCK") |> 
  # Pad series with middle category
  mutate(
    series = case_when(
      str_count(series, " ;") == 2 ~ sub(" ;", " ; Total ;", series),
      TRUE ~ series
    )
  )|> 
  separate_wider_delim(series, names = c("state", "attendance", "status", "junk"), delim = " ;") |> 
  transmute(
    month = yearmonth(date),
    across(c(state, attendance, status), trimws),
    series_id, value = value * 1000
  ) |> 
  as_tsibble(index = month, key = c(state, attendance, status))

aus_students |> 
  filter(status == "Employed total", state == "Australia") |>
  autoplot(value)

aus_students |> 
  filter(status == "Employed total", attendance == "Attending full-time education") |>
  autoplot(value)
