# _targets.R file:
library(targets)
library(tarchetypes)
library(tibble)

  target1 <- targets::tar_target(x, head(mtcars))
  target2 <- targets::tar_target(y, tail(mtcars))
  target3 <- tarchetypes::tar_combine(
    new_target_name,
    target1,
    target2,
    command = dplyr::bind_rows(!!!.x)
  )
  list(target1, target2, target3)
