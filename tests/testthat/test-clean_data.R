source(file.path("..", "..", "R", "clean_data.R"))

test_that("stat_mode returns the most frequent value", {
  expect_equal(stat_mode(c("a", "b", "b", "c")), "b")
  expect_equal(stat_mode(c(1, 1, 2)), 1)
})

test_that("stat_mode ignores missing values", {
  expect_equal(stat_mode(c(NA, "x", NA, "y", "y")), "y")
  expect_true(is.na(stat_mode(c(NA, NA))))
  expect_true(is.na(stat_mode(character(0))))
})

test_that("clean_catf collapses to one row per country", {
  raw <- data.frame(
    country = c("A", "A", "A", "B"),
    SAIDI = c(10, 20, NA, 5),
    region = c("North", "North", "South", "West")
  )
  out <- clean_catf(raw)

  expect_equal(nrow(out), 2)
  expect_equal(out$SAIDI[out$country == "A"], 15)
  expect_equal(out$region[out$country == "A"], "North")
  expect_equal(out$n_sources, c(3, 1))
})

test_that("clean_catf uses the median, so one source in other units does not dominate", {
  raw <- data.frame(
    country = rep("A", 4),
    electrification_rate = c(99, 100, 100, 1) # one source reports a fraction
  )
  expect_equal(clean_catf(raw)$electrification_rate, 99.5)
})

test_that("the real dataset cleans to one row per country", {
  data_path <- file.path("..", "..", "data", "CATF_data.csv")
  skip_if_not(file.exists(data_path), "CATF_data.csv is not available")
  raw <- readr::read_csv(data_path, show_col_types = FALSE)
  out <- clean_catf(raw)
  expect_equal(nrow(out), dplyr::n_distinct(raw$country))
  expect_false(any(duplicated(out$country)))
})
