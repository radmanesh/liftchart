# liftchart

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**liftchart** is an R package that provides tools for calculating and plotting cumulative gain and lift charts, which are essential for evaluating the performance of predictive classification models. These charts help visualize the effectiveness of a model by showing how well it distinguishes between classes across different segments of data.

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
- [Examples](#examples)
  - [Using Synthetic Data](#using-synthetic-data)
  - [Using the Iris Dataset](#using-the-iris-dataset)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Installation

You can install the development version of **liftchart** from GitHub:

```R
# Install devtools if you haven't already
install.packages("devtools")

# Install liftchart from GitHub
devtools::install_github("radmanesh/liftchart")
```
## Getting Started

Load the package and any necessary dependencies:

```R
library(liftchart)
library(ggplot2)  # Optional, for additional plotting features
```
## Examples

### Using Synthetic Data

```R
# Generate synthetic data
set.seed(123)
data <- data.frame(
  actual = rbinom(1000, 1, 0.3),              # Actual binary outcomes
  predicted = runif(1000, min = 0, max = 1)   # Predicted probabilities
)

# Calculate lift chart data
lift_data <- lift_chart_data(data, actual = "actual", predicted = "predicted", groups = 10)

# Print the lift chart data
print(lift_data)

# Plot cumulative gains chart
plot_cumulative_gain(lift_data)
```
## Documentation

For detailed usage instructions and additional examples, please refer to the [package vignette](https://github.com/vignettes/introduction.html) or the function documentation in the man/ directory.

## Contributing

Contributions are welcome! If you’d like to contribute, please follow these steps:

1. Fork the repository on GitHub.
2. Clone your forked repository to your local machine.
3. Create a new branch for your feature or bug fix: `git checkout -b feature/YourFeatureName`.
4. Make your changes and commit them with clear commit messages.
5. Push your changes to your forked repository: `git push origin feature/YourFeatureName`.

. Open a Pull Request on the original repository.

Please ensure that your code adheres to the existing style guidelines and that all tests pass.

License

This project is licensed under the terms of the MIT License. See the LICENSE file for details.

Contact

Author: Arman Radmanesh
Email: radmanesh@gmail.com
GitHub: [radmanesh](https://github.com/radmanesh) 


```markdown
[![R-CMD-check](https://github.com/radmanesh/liftchart/workflows/R-CMD-check/badge.svg)](https://github.com/radmanesh/liftchart/actions)
```
```