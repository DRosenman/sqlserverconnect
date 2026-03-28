# Using sqlserverconnect with Shiny

## Why use connection pools in Shiny?

A plain DBI connection is fine for scripts, but Shiny apps can serve
multiple users simultaneously. Opening a fresh connection per request is
slow and can exhaust your server’s connection limit. A **connection
pool** solves this by maintaining a set of reusable connections that are
checked out and returned automatically.

`sqlserverconnect` makes this a one-argument switch: `pool = TRUE`.

## DBI vs pool: when to use which?

| Use case            | `pool = FALSE` (default)       | `pool = TRUE`                          |
|---------------------|--------------------------------|----------------------------------------|
| Interactive scripts | Simple and direct              | Usually unnecessary                    |
| Long-running jobs   | May time out if idle           | Better handling of idle connections    |
| Shiny apps          | Risk of too many connections   | Recommended best practice              |
| Parallel workloads  | Each worker opens its own conn | Pool can reuse connections per process |

## Basic Shiny setup

Create the pool once at startup, use it in your server logic, and close
it when the app stops:

``` r
# app.R (or global.R)
library(sqlserverconnect)
library(shiny)
library(DBI)

# Create pool at startup
db_pool <- db_connect(
  server   = "localhost",
  database = "master",
  pool     = TRUE
)

# Close pool when app stops
onStop(function() {
  db_disconnect(db_pool)
})

ui <- fluidPage(
  tableOutput("databases")
)

server <- function(input, output, session) {
  output$databases <- renderTable({
    DBI::dbGetQuery(db_pool, "SELECT TOP (10) name, create_date FROM sys.databases")
  })
}

shinyApp(ui, server)
```

## Key points

**Create the pool once.** Put `db_connect(pool = TRUE)` in `global.R` or
at the top of `app.R`, not inside `server`. Creating a pool per session
defeats the purpose.

**Use `onStop()` for cleanup.** This ensures the pool is closed when the
app shuts down, releasing all connections back to the server.

**Query the pool like a regular connection.** You can pass it directly
to
[`DBI::dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html),
[`DBI::dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html),
and other DBI functions. The pool handles checkout/return behind the
scenes.

**[`db_disconnect()`](https://drosenman.github.io/sqlserverconnect/reference/db_disconnect.md)
works for both.** You don’t need to remember whether you created a DBI
connection or a pool —
[`db_disconnect()`](https://drosenman.github.io/sqlserverconnect/reference/db_disconnect.md)
detects the type and calls the right cleanup function.

## Reactive queries

For queries that depend on user input, use them inside reactive
expressions as usual:

``` r
server <- function(input, output, session) {
  table_data <- reactive({
    req(input$table_name)
    query <- paste0("SELECT TOP (100) * FROM ", input$table_name)
    DBI::dbGetQuery(db_pool, query)
  })

  output$data <- renderTable({
    table_data()
  })
}
```

**Note:** Be careful with user-supplied table names — in production,
validate them against a known list or use parameterized queries to avoid
SQL injection.
