library(tidyverse)

source("scripts/helpers.R")

awards <- fs::dir_ls("data/source/", regexp = "\\.csv$") %>% 
  map_dfr(
    read_csv,
    .id = "source_file",
    locale = locale(encoding = "ISO-8859-1"),
    col_types = cols("AwardAmount" = col_character())
  )

t <- awards %>% mutate(
  AwardDollarsA = str_remove_all(AwardAmount, fixed("$")),
  AwardDollarsB = str_remove_all(AwardDollarsA, fixed(",")),
  AwardDollarsDbl = as.double(AwardDollarsB)
)
