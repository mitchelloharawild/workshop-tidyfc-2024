library(tidyverse)
library(fpp3)

students <- readxl::read_excel("data/schools/Table 42b Number of Full-time and Part-time Students - 2006-2023.xlsx", sheet = 3, skip = 4)

students |> 
  distinct(`State/Territory`)

students |> 
  distinct(Year)
students |> 
  group_by(Year, `Affiliation (Gov/Cath/Ind)`) |> 
  summarise(students = sum(`All Full-time and Part-time Student count`)) |> 
  ggplot(aes(x = Year, y= students)) + 
  geom_line(aes(colour = `Affiliation (Gov/Cath/Ind)`))



teacher_ratio <- readxl::read_excel("data/schools/Table 53a Student (FTE) to Teaching Staff (FTE) Ratios, 2006-2023.xlsx", sheet = 2, skip = 4)

teacher_ratio |> 
  group_by(Year, `School Level` = stringr::str_to_sentence(`School Level`)) |> 
  summarise(ratio = mean(`Student to Teaching Staff Ratio`)) |> 
  ggplot(aes(x = Year, y = ratio)) + 
  geom_line(aes(colour = `School Level`))

readxl::excel_sheets("data/schools/Table 50a In-school Staff (Number), 2006-2023.xlsx")

staff <- readxl::read_excel("data/schools/Table 50a In-school Staff (Number), 2006-2023.xlsx", sheet = 3, skip = 4)

staff |> 
  as_tsibble(index = Year,
             key = where(is.character))

staff |> 
  group_by(Year, `Affiliation 2`) |> 
  summarise(staff = sum(`In-School Staff Count`)) |> 
  ggplot(aes(x = Year, y = staff)) + 
  geom_line(aes(colour = `Affiliation 2`))



students <- read_excel(
  "data/schools/Table 42b Number of Full-time and Part-time Students - 2006-2023.xlsx",
  sheet = 3, skip = 4
) |> 
  # Group by Year and all the character variables
  group_by(Year, across(where(is.character), identity)) |> 
  # Add up the duplicate rows
  summarise(across(ends_with("count"), sum), .groups = "drop") |> 
  # Convert to a tsibble
  as_tsibble(
    key = where(is.character),
    index = Year
  )