#' Disconnect from a SQL Server connection or pool
#'
#' @param conn A DBI connection or a pool connection object
#' @param quiet (logical) if TRUE, suppresses messages
#'
#' @return TRUE (invisibly) if disconnected, FALSE otherwise
#'
#' @examples
#' \dontrun{
#' # Establish a connection
#' conn <- db_connect(
#'   server   = "localhost",
#'   database = "master",
#'   quiet    = TRUE
#' )
#'
#' # Disconnect when finished
#' db_disconnect(conn)
#'
#' # Disconnecting a NULL connection
#' db_disconnect(NULL)
#' }
#'
#' @export
db_disconnect <- function(conn, quiet = FALSE) {

  # NULL or missing connection
  if (is.null(conn)) {
    if (!quiet) cli::cli_alert_info("No connection to disconnect.")
    invisible(FALSE)
  }

  # Pool connection
  if (inherits(conn, "pool")) {
    pool::poolClose(conn)
    if (!quiet) cli::cli_alert_success("Pooled connection closed.")
    invisible(TRUE)
  }

  # DBI connection
  if (inherits(conn, "DBIConnection")) {
    try(DBI::dbDisconnect(conn), silent = TRUE)
    if (!quiet) cli::cli_alert_success("Database connection closed.")
    invisible(TRUE)
  }

  # Unknown object type
  if (!quiet) cli::cli_alert_warning("Object is not a DBI connection or pool.")
  invisible(FALSE)
}
