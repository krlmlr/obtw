stack_env <- new_environment()

#' @export
obtw_pop <- function(x) {
  if (is.null(stack_env$stack)) {
    stack_env$stack <- collections::stack()
    withr::defer({
      stack_env$stack <- NULL
    })
  }

  force(x)

  stack_env$stack$pop()
}

#' @export
obtw_peek <- function(x) {
  if (is.null(stack_env$stack)) {
    stack_env$stack <- collections::stack()
    withr::defer({
      stack_env$stack <- NULL
    })
  }

  force(x)

  stack_env$stack$peek()
}

#' @export
obtw_push <- function(x) {
  if (!is.null(stack_env$stack)) {
    stack_env$stack$push(x)
  }

  x
}
