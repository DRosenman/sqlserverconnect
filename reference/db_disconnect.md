# Disconnect from a SQL Server connection or pool

Disconnect from a SQL Server connection or pool

## Usage

``` r
db_disconnect(conn, quiet = FALSE)
```

## Arguments

- conn:

  A DBI connection or a pool connection object

- quiet:

  (logical) if TRUE, suppresses messages

## Value

TRUE (invisibly) if disconnected, FALSE otherwise

## Examples

``` r
# \donttest{
# Establish a connection
conn <- db_connect(
  server   = "localhost",
  database = "master",
  quiet    = TRUE
)
#> Error in pkgdown::build_site_github_pages(new_process = FALSE, install = TRUE): ! ODBC failed with error 00000 from [unixODBC][Driver Manager].
#> ✖ Can't open lib 'ODBC Driver 17 for SQL Server' : file not found
#> ℹ From nanodbc/nanodbc.cpp:1184.

# Disconnect when finished
db_disconnect(conn)
#> Error: object 'conn' not found

# Disconnecting a NULL connection
db_disconnect(NULL)
#> ℹ No connection to disconnect.
# }
```
