library(tidyverse)

source("scripts/helpers.R")

## Data from: https://open.canada.ca/data/en/dataset/b4e2b302-9bc6-4b33-b880-6496f8cef0f1
files <- tibble(path = fs::dir_ls("data/source/", regexp = "\\.csv$")) %>%
  mutate(year = as.integer(str_extract(path, "[0-9]{4}"))) %>%
  mutate(original_schema = year < 2016)

awards_schema_1 <- files %>%
  filter(original_schema) %>%
  pull(path) %>%
  map_dfr(
    read_csv,
    .id = "source_file",
    locale = locale(encoding = "ISO-8859-1"),
    col_types = cols("AwardAmount" = col_character())
  )

awards_schema_2 <- files %>%
  filter(! original_schema) %>%
  pull(path) %>%
  map_dfr(
    read_csv,
    .id = "source_file",
    locale = locale(encoding = "ISO-8859-1")
  )

## Compare names! (hint: they differ)
awards_schema_1 %>% names()
awards_schema_2 %>% names()

t <- awards %>% mutate(
  AwardDollars = str_remove_all(AwardAmount, "\\$|,")
) %>% mutate(
  AwardDollars = as.double(AwardDollars)
)

