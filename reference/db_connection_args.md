# Build SQL Server connection arguments

Build SQL Server connection arguments

## Usage

``` r
db_connection_args(
  server,
  database,
  uid = NULL,
  pwd = NULL,
  port = NULL,
  trusted = TRUE,
  driver = "ODBC Driver 17 for SQL Server"
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

## Value

A named list of arguments suitable for a SQL Server connection string in
DBI::dbConnect() or pool::dbPool(). Used internally by
[`db_connect()`](db_connect.md) to construct the argument list.

## Examples

``` r
# Build arguments using Windows authentication
db_connection_args(
  server   = "localhost",
  database = "master"
)
#> $Driver
#> [1] "ODBC Driver 17 for SQL Server"
#> 
#> $Server
#> [1] "localhost"
#> 
#> $Database
#> [1] "master"
#> 
#> $Trusted_Connection
#> [1] "Yes"
#> 

# Build arguments using SQL authentication
db_connection_args(
  server   = "localhost",
  database = "master",
  uid      = "sa",
  pwd      = "password",
  trusted  = FALSE
)
#> $Driver
#> [1] "ODBC Driver 17 for SQL Server"
#> 
#> $Server
#> [1] "localhost"
#> 
#> $Database
#> [1] "master"
#> 
#> $UID
#> [1] "sa"
#> 
#> $PWD
#> [1] "password"
#> 
```
