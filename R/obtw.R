#' @export
obtw <- function(checker) {
  function(x, ...) {
    pre_cnd <- force_with_check_restart(x)

    validate_pre <- tryCatch(
      {
        checker(x, ...)
        TRUE
      },
      error = function(e) {
        validate_if(TRUE, conditionMessage(e), pre_cnd)
        FALSE
      }
    )

    if (validate_pre && !is.null(pre_cnd)) {
      validate_signal(pre_cnd)
    }

    x
  }
}
