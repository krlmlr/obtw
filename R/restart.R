force_with_check_restart <- function(x) {
  cnd <- NULL
  withCallingHandlers(
    force(x),
    obtw_error = function(e) {
      cnd <<- e

      r <- findRestart("my_cnd_check_restart")
      if (is.null(r)) return()

      invokeRestart(r)
    }
  )
  cnd
}

validate_if <- function(cond, msg, pre_cnd) {
  if (cond) {
    validate_signal(error_cnd(message = msg), pre_cnd)
  } else if (!is.null(pre_cnd)) {
    validate_signal(pre_cnd)
  }
}

validate_signal <- function(cnd, pre_cnd = NULL) {
  class(cnd) <- c("obtw_error", class(cnd))

  if (is.null(pre_cnd)) {
    pre_cnd <- cnd
  } else {
    pre_cnd$other_cnd <- c(pre_cnd$other_cnd, list(cnd))
  }

  withRestarts(
    "my_cnd_check_restart" = function(e) NULL,
    rlang::cnd_signal(pre_cnd)
  )
}
