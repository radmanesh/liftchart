#' Calculate Lift Chart Data
#'
#' @param data A data frame containing the actual and predicted values.
#' @param actual The name of the actual (dependent variable) column as a string.
#' @param predicted The name of the predicted scores/probabilities column as a string.
#' @param groups Number of groups (deciles). Default is 10.
#'
#' @return A data frame with lift chart calculations.
#' @export
#'
#' @examples
#' data <- data.frame(actual = rbinom(100, 1, 0.6), predicted = runif(100))
#' lift_data <- lift_chart_data(data, actual = "actual", predicted = "predicted")
#' print(lift_data)
lift_chart_data <- function(data, actual, predicted, groups = 10) {
  # Check if required packages are installed
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required but not installed.")
  }

  if (!requireNamespace("rlang", quietly = TRUE)) {
    stop("Package 'rlang' is required but not installed.")
  }

  # Convert column names to symbols
  actual_col <- rlang::sym(actual)
  predicted_col <- rlang::sym(predicted)

  # Input validation
  if (!all(c(actual, predicted) %in% names(data))) {
    stop("Specified columns do not exist in the data.")
  }

  if (!is.numeric(data[[actual]])) {
    stop("Actual values must be numeric.")
  }

  if (!is.numeric(data[[predicted]])) {
    stop("Predicted values must be numeric.")
  }

  # Create deciles
  data <- data |>
    dplyr::mutate(bucket = dplyr::ntile(-!!predicted_col, groups))

  # Calculate gain table
  gain_table <- data |>
    dplyr::group_by(bucket) |>
    dplyr::summarise(
      total = dplyr::n(),
      totalresp = sum(!!actual_col, na.rm = TRUE),
      .groups = 'drop'
    ) |>
    dplyr::mutate(
      cumresp = cumsum(totalresp),
      gain = cumresp / sum(totalresp) * 100,
      cumlift = gain / (bucket * (100 / groups))
    )

  return(gain_table)
}

#' Plot Cumulative Gains Chart
#'
#' @param gain_table Data frame returned by `lift_chart_data`.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' data <- data.frame(actual = rbinom(100, 1, 0.6), predicted = runif(100))
#' lift_data <- lift_chart_data(data, actual = "actual", predicted = "predicted")
#' plot_cumulative_gain(lift_data)
plot_cumulative_gain <- function(gain_table) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required but not installed.")
  }

  # Prepare data
  gain_table <- gain_table |>
    dplyr::add_row(bucket = 0, gain = 0, .before = 1) |>
    dplyr::arrange(bucket)

  # Plot
  p <- ggplot2::ggplot(gain_table, ggplot2::aes(x = bucket, y = gain)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::geom_abline(slope = max(gain_table$gain) / max(gain_table$bucket), intercept = 0, linetype = "dashed") +
    ggplot2::scale_y_continuous(breaks = seq(0, 100, by = 20), limits = c(0, 100)) +
    ggplot2::scale_x_continuous(breaks = seq(0, max(gain_table$bucket), by = 1)) +
    ggplot2::labs(title = "Cumulative Gains Plot", x = "Decile", y = "Cumulative Gain (%)") +
    ggplot2::theme_minimal()

  return(p)
}
