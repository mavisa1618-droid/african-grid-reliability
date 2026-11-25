# Data cleaning helpers for the CATF electricity dataset.
#
# The raw file has several rows per country (one per data source).
# clean_catf() collapses it to one row per country.

.data <- rlang::.data

#' Most frequent non-missing value of a vector (NA if all values are missing).
stat_mode <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) {
    return(NA)
  }
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#' Collapse the raw CATF data to one row per country.
#'
#' Numeric columns use the median across sources (robust to a single
#' source reporting in different units); character columns use the mode.
#' `n_sources` records how many source rows each country had.
clean_catf <- function(raw) {
  numeric_cols <- raw |>
    dplyr::select(dplyr::where(is.numeric)) |>
    names()

  character_cols <- raw |>
    dplyr::select(dplyr::where(is.character), -"country") |>
    names()

  raw |>
    dplyr::group_by(.data$country) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(numeric_cols), function(x) median(x, na.rm = TRUE)),
      dplyr::across(dplyr::all_of(character_cols), stat_mode),
      n_sources = dplyr::n()
    )
}
