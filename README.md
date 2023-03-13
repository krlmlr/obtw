
<!-- README.md is generated from README.Rmd. Please edit that file -->

# obtw

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Oh, by the way: the goal of this package is to offer a set of
lightweight tools to simplify data checks in a pipeline.

This package provides two convenience features for working with data
transformation pipelines:

- A stack, for pushing the current result and retrieving it for later
  use

- A validation framework, for reporting multiple failures in a pipeline

## Installation

You can install the development version of obtw like so:

``` r
pak::pak("krlmlr/obtw")
```

(Follow the [installation
instructions](https://pak.r-lib.org/#arrow_down-installation) to install
pak.)

## Checking one or multiple conditions

``` r
library(obtw)

test_df <- data.frame(a = 1:3, b = 2:4, c = 1)

# Success returns the input unchanged:
test_df |> 
  obtw_check_df(a <= 3)
#>   a b c
#> 1 1 2 1
#> 2 2 3 1
#> 3 3 4 1

# Failure triggers an error:
test_df |> 
  obtw_check_df(a < 3)
#> Error:
#> ! 1 rows failed check: a < 3

# Multiple failures are collected and reported together:
test_df |> 
  obtw_check_df(a < 3) |> 
  obtw_check_df(b > 0) |> 
  obtw_check_df(b < 4)
#> Error:
#> ! 1 rows failed check: a < 3
#> 1 other failing check(s):
#> <error/obtw_error>
#> Error:
#> ! 1 rows failed check: b < 4
```

## Integrate with other pipe-friendly checking packages

``` r
test_df |> 
  obtw_check_df(a < 3) |> 
  obtw(dm::check_key)(c) |> 
  obtw(ensurer::ensure)(nrow(.) == 4) |> 
  obtw(pointblank::col_is_factor)(b) |> 
  obtw(assertr::verify)(a > 7) |> 
  obtw(assertive::assert_is_of_length)(2)
#> verification [a > 7] failed! (3 failures)
#> 
#>     verb redux_fn predicate column index value
#> 1 verify       NA     a > 7     NA     1    NA
#> 2 verify       NA     a > 7     NA     2    NA
#> 3 verify       NA     a > 7     NA     3    NA
#> Error:
#> ! 1 rows failed check: a < 3
#> 5 other failing check(s):
#> <error/obtw_error>
#> Error:
#> ! (`c`) not a unique key of `x`.
#> <error/obtw_error>
#> Error:
#> ! conditions failed for call 'rmarkdown::render(" .. encoding = "UTF-8")':
#>   * nrow(.) == 4
#> <error/obtw_error>
#> Error:
#> ! Failure to validate that column `b` is of type: factor.
#> The `col_is_factor()` validation failed beyond the absolute threshold level (1).
#> * failure level (1) >= failure threshold (1)
#> <error/obtw_error>
#> Error:
#> ! assertr stopped execution
#> <error/obtw_error>
#> Error:
#> ! is_of_length : x has length 3, not 2.
```

## Perform destructive tests on your data

``` r
# Push with obtw_push(), continue working on your original data with obtw_pop():
test_df |> 
  obtw_push() |> 
  nrow() |>
  obtw(assertive::assert_all_are_greater_than)(1) |> 
  obtw_pop()
#>   a b c
#> 1 1 2 1
#> 2 2 3 1
#> 3 3 4 1

# Report all failing checks:
test_df |> 
  obtw_push() |> 
  nrow() |>
  obtw(assertive::assert_all_are_greater_than)(3) |> 
  obtw(assertive::assert_all_are_less_than)(7) |> 
  obtw(assertive::assert_all_are_even)() |> 
  obtw_pop()
#> Error:
#> ! is_greater_than : x are not all greater than 3.
#> There was 1 failure:
#>   Position Value                   Cause
#> 1        1     3 less than or equal to 3
#> 1 other failing check(s):
#> <error/obtw_error>
#> Error:
#> ! is_even : x are not all even (tol = 2.22045e-14).
#> There was 1 failure:
#>   Position Value       Cause
#> 1        1     3 indivisible

# Combine with obtw_check_df():
test_df |> 
  obtw_push() |> 
  dplyr::summarize(b = mean(b)) |> 
  obtw_check_df(b == 2) |> 
  obtw_pop()
#> Error:
#> ! 1 rows failed check: b == 2
```
