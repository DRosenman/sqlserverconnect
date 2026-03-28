# Getting Started with sqlserverconnect

## Overview

`sqlserverconnect` provides a minimal wrapper around **DBI**, **odbc**,
and **pool** to make connecting to Microsoft SQL Server as painless as
possible. The package exports three functions:

- [`db_connect()`](https://drosenman.github.io/sqlserverconnect/reference/db_connect.md)
  – open a DBI connection or a connection pool
- [`db_disconnect()`](https://drosenman.github.io/sqlserverconnect/reference/db_disconnect.md)
  – safely close either one
- [`db_connection_args()`](https://drosenman.github.io/sqlserverconnect/reference/db_connection_args.md)
  – build the connection arguments list without actually connecting
  (useful for debugging)

## Windows Authentication (trusted connection)

This is the most common setup in corporate environments. Windows passes
your credentials automatically, so you don’t need to supply a username
or password. Just set `trusted = TRUE` (the default):

``` r
library(sqlserverconnect)
library(DBI)

conn <- db_connect(
  server   = "localhost",
  database = "master"
)

DBI::dbGetQuery(conn, "SELECT TOP (5) name, create_date FROM sys.databases")

db_disconnect(conn)
```

## SQL Server Authentication (username + password)

For SQL auth, set `trusted = FALSE` and provide `uid` and `pwd`. Avoid
hardcoding passwords — use environment variables, the
[keyring](https://cran.r-project.org/package=keyring) package, or
another secret manager.

``` r
conn <- db_connect(
  server   = "localhost",
  database = "master",
  uid      = Sys.getenv("SQLSERVER_UID"),
  pwd      = Sys.getenv("SQLSERVER_PWD"),
  trusted  = FALSE
)

DBI::dbGetQuery(conn, "SELECT TOP (5) name FROM sys.tables")

db_disconnect(conn)
```

You can set the environment variables in your `.Renviron` file:

    SQLSERVER_UID=my_username
    SQLSERVER_PWD=my_password

Then restart R so they take effect.

## Inspecting connection arguments

If you want to see exactly what
[`db_connect()`](https://drosenman.github.io/sqlserverconnect/reference/db_connect.md)
would pass to
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
without actually opening a connection, use
[`db_connection_args()`](https://drosenman.github.io/sqlserverconnect/reference/db_connection_args.md):

``` r
args <- db_connection_args(
  server   = "localhost",
  database = "master",
  trusted  = TRUE
)

str(args)
```

This is handy for debugging driver issues or verifying your connection
string.

## Custom port

SQL Server defaults to port 1433. If your instance uses a different
port, pass it directly:

``` r
conn <- db_connect(
  server   = "myserver",
  database = "mydb",
  port     = 1434
)
```

## Named instances

For named instances, include the instance name in the `server` argument:

``` r
conn <- db_connect(
  server   = "myserver\\SQLEXPRESS",
  database = "mydb"
)
```
