
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mssqlr

<!-- badges: start -->

<!-- badges: end -->

`mssqlr` provides a minimal, user-friendly interface for connecting to
Microsoft SQL Server from R.  
It wraps `DBI`, `odbc`, and `pool` with a small set of clean, consistent
helpers:

- `db_connect()` – establish a DBI (default) or pooled connection  
- `db_disconnect()` – safely close DBI or pooled connections

Although most users will interact only with these two functions, the
package also includes:

- `db_connection_args()` – constructs a standardized list of connection
  arguments used internally by `db_connect()`

The goal is to offer a lightweight, expressive API without the
boilerplate typically required for SQL Server connections.

## Installation

You can install the development version of **mssqlr** from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("drosenman/mssqlr")
```

## Example

Here’s a simple example showing how to connect and disconnect:

``` r
library(mssqlr)

# Connect to a SQL Server database
conn <- db_connect(
  server   = "localhost",
  database = "master"
)

# ... use the connection ...
DBI::dbGetQuery(conn, "SELECT * FROM sys.tables")

# Disconnect when finished
db_disconnect(conn)
```

## Why use mssqlr?

- Minimal surface area  
- Clear, explicit arguments  
- Works with both DBI and pooled connections  
- No unnecessary abstractions

If you frequently connect to SQL Server from R, this package keeps your
workflow clean and consistent.
