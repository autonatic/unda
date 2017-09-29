# time series (regular data)
# monthly
ts1 <- ts(rnorm(300),
          start = c(1995,1),
          frequency = 12)

# quarterly
ts2 <- ts(rnorm(100),
          start = c(1995,1),
          frequency = 4)

