test_that("lift_chart_data works correctly", {
  data <- data.frame(actual = rbinom(100, 1, 0.6), predicted = runif(100))
  result <- lift_chart_data(data, actual = "actual", predicted = "predicted")

  expect_s3_class(result, "data.frame")
  expect_true(all(c("bucket", "total", "totalresp", "cumresp", "gain", "cumlift") %in% names(result)))
})

test_that("plot_cumulative_gain returns a ggplot object", {
  data <- data.frame(actual = rbinom(100, 1, 0.6), predicted = runif(100))
  lift_data <- lift_chart_data(data, actual = "actual", predicted = "predicted")
  p <- plot_cumulative_gain(lift_data)

  expect_s3_class(p, "ggplot")
})
