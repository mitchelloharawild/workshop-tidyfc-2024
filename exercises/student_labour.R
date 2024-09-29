library(tsibble)
library(readabs)
library(dplyr)
student_labour <- read_abs("6202.0", tables = "16") |> 
  filter(series_type == "Original", data_type == "STOCK") |> 
  # Pad series with middle category
  mutate(
    series = case_when(
      str_count(series, " ;") == 2 ~ sub(" ;", " ; Total ;", series),
      TRUE ~ series
    )
  )|> 
  # Split series into separate variables
  separate_wider_delim(series, names = c("state", "attendance", "status", "junk"), delim = " ;") |> 
  # Clean up variable values and names
  transmute(
    month = yearmonth(date),
    across(c(state, attendance, status), function(x) sub("^> ", "", trimws(x))),
    series_id, persons = value * 1000
  ) |> 
  # Remove aggregates
  filter(state != "Australia", attendance != "Total", !grepl("total$", status)) |> 
  # Construct tsibble
  as_tsibble(index = month, key = c(state, attendance, status))
readr::write_rds(student_labour, "exercises/data/student_labour.rds")
