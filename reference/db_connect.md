# Connect to a SQL Server database

Connect to a SQL Server database

## Usage

``` r
db_connect(
  server,
  database,
  uid = NULL,
  pwd = NULL,
  port = NULL,
  trusted = TRUE,
  driver = "ODBC Driver 17 for SQL Server",
  pool = FALSE,
  quiet = FALSE,
  ...
)
```

## Arguments

- server:

  SQL Server hostname, IP address, or instance name

- database:

  Database name

- uid:

  Username (ignore/keep as NULL if trusted = TRUE)

- pwd:

  Password (ignore/keep as NULL if trusted = TRUE)

- port:

  Optional port number. If NULL, odbc package handles port resolution

- trusted:

  (logical) If TRUE (default), uses Windows authentication

- driver:

  ODBC driver name (default is "ODBC Driver 17 for SQL Server")

- pool:

  (logical) if TRUE, returns a pooled connection

- quiet:

  (logical) if TRUE, suppresses messages

- ...:

  Additional arguments passed to DBI::dbConnect or pool::dbPool

## Value

A DBI connection or a pool object

## Examples

``` r
# \donttest{
# Connect to a SQL Server database
conn <- db_connect(
  server   = "localhost",
  database = "master",
  quiet    = TRUE
)
#> Error in db_connect(server = "localhost", database = "master", quiet = TRUE): ! ODBC failed with error 00000 from [unixODBC][Driver Manager].
#> ✖ Can't open lib 'ODBC Driver 17 for SQL Server' : file not found
#> ℹ From nanodbc/nanodbc.cpp:1184.

# Run a simple query
DBI::dbGetQuery(conn, "SELECT name FROM sys.databases")
#> Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbGetQuery': object 'conn' not found

# Disconnect when finished
db_disconnect(conn)
#> Error: object 'conn' not found
# }
```
