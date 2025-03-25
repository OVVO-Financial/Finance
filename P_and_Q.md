# Illustrative Example: Why `NNS.rescale()` is Necessary

Let’s say you’re modeling stock prices and need to ensure your simulated data aligns with financial theory or practical constraints. Here’s an example to illustrate why `NNS.rescale()` is valuable:

## Scenario
You’ve generated a set of terminal stock prices over 1 year in a manner reminiscent of a geometric Brownian motion (though not a full risk-neutral GBM). This example simply illustrates how `NNS.rescale()` can adjust such simulated data so that the mean aligns with a theoretical expectation (e.g., risk-neutral pricing):
```r
> set.seed(1234) 
> prices <- 100 * exp(cumsum(rnorm(100, 0.001, 0.02)))
> mean(prices) 
[1] 78.41677
```

- Initial price = 100
- Risk-free rate = 0.05
- Time to maturity = 1 year

In a risk-neutral world (common in options pricing), the expected value of the terminal prices should be approximately 105.13 (calculated as the initial price adjusted by the risk-free rate over time), not 78.42. 
This exaggerated discrepancy arises because the simulation’s mean depends on random draws and an arbitrary drift, not a risk-neutral framework.

## Without Rescaling
If you use these prices directly in a pricing model, your results won’t align with the theoretical framework, leading to mispriced options or inaccurate risk assessments.

## With `NNS.rescale()`
Using the risk-neutral method, you could now run: 
```r
> rescaled <- NNS.rescale(prices, a = 100, b = 0.05, method = "riskneutral", T = 1, type = "Terminal")
> mean(rescaled)
[1] 105.1271   
```
The function adjusts the entire distribution so its mean matches the expected value of 105.13, keeping the shape of the data intact while meeting the risk-neutral requirement.  Alternatively, if you’re working with discounted values and need the mean to match the initial price of 100, you could use:
```r
> rescaled_discounted <- NNS.rescale(prices, a = 100, b = 0.05, method = "riskneutral", T = 1, type = "Discounted")
> mean(rescaled_discounted)
[1] 100
```

## Why It’s Necessary
- **Flexibility**: The same function handles both min-max scaling (e.g., normalizing to [0, 1] for machine learning) and risk-neutral adjustments (critical for finance).
- **Consistency**: Ensures simulated or empirical data aligns with theoretical models.
- **Practicality**: Simplifies workflows by embedding these adjustments into a single, reusable tool.

This makes `NNS.rescale()` a must-have for anyone juggling data normalization and financial modeling!

# Comprehensive Study: Impact of Dynamic Rescaling on GBM Paths and Terminal Distributions


```r
# Parameters
S0 <- 100
r <- 0.05
T <- 1
sigma <- 0.2
n <- 100
dt <- T / n
n_paths <- 10000

set.seed(1234)
drift <- (r - 0.5 * sigma^2) * dt
vol <- sigma * sqrt(dt)

# Function to compute log-returns for a single path
compute_log_returns <- function(prices) {
  log_returns <- diff(log(prices))
  return(log_returns)
}

# Function to compute annualized volatility for a single path
compute_path_volatility <- function(prices, dt) {
  log_returns <- compute_log_returns(prices)
  sqrt(var(log_returns) / dt)
}

# 1. Normal GBM simulation
paths_normal <- matrix(NA, nrow = n + 1, ncol = n_paths)
paths_normal[1, ] <- S0

for (i in 1:n) {
  increments <- rnorm(n_paths, mean = drift, sd = vol)
  paths_normal[i + 1, ] <- paths_normal[i, ] * exp(increments)
}

# 2. Dynamic rescaling simulation
paths_rescaled <- matrix(NA, nrow = n + 1, ncol = n_paths)
paths_rescaled[1, ] <- S0

for (i in 1:n) {
  increments <- rnorm(n_paths, mean = drift, sd = vol)
  next_prices <- paths_rescaled[i, ] * exp(increments)
  t_i <- i * dt
  target_mean <- S0 * exp(r * t_i)
  rescaled <- NNS.rescale(next_prices, a = S0, b = r, method = "riskneutral", T = t_i, type = "Terminal")
  paths_rescaled[i + 1, ] <- rescaled
}

# Compute theoretical means at each step
time_steps <- seq(0, T, by = dt)
theoretical_means <- S0 * exp(r * time_steps)

# Compute sample means at each step
sample_means_normal <- rowMeans(paths_normal)
sample_means_rescaled <- rowMeans(paths_rescaled)

# Compute differences (sample mean - theoretical mean)
diff_normal <- sample_means_normal - theoretical_means
diff_rescaled <- sample_means_rescaled - theoretical_means

# Report results for a few selected time steps
selected_steps <- c(1, 26, 51, 76, 101)  # t = 0, 0.25, 0.5, 0.75, 1
cat("Step-wise comparison of sample means vs. theoretical means:\n")
cat("Step | Time | Theoretical Mean | Normal GBM Mean | Normal Diff | Rescaled Mean | Rescaled Diff\n")
cat("------------------------------------------------------------------------------------\n")
for (idx in selected_steps) {
  step <- idx - 1
  t_i <- time_steps[idx]
  cat(sprintf("%4d | %.2f | %.4f         | %.4f        | %.4f    | %.4f       | %.4f\n",
              step, t_i, theoretical_means[idx], sample_means_normal[idx],
              diff_normal[idx], sample_means_rescaled[idx], diff_rescaled[idx]))
}

# Compute path volatilities (for reference)
vols_normal <- apply(paths_normal, 2, compute_path_volatility, dt = dt)
vols_rescaled <- apply(paths_rescaled, 2, compute_path_volatility, dt = dt)

# Terminal price statistics (for reference)
terminal_normal <- paths_normal[n + 1, ]
terminal_rescaled <- paths_rescaled[n + 1, ]

# Additional summary statistics
cat("\nSummary Statistics:\n")
cat("Mean path volatility (normal GBM):", mean(vols_normal), "\n")
cat("Mean path volatility (rescaled GBM):", mean(vols_rescaled), "\n")
cat("Mean of terminal prices (normal GBM):", mean(terminal_normal), "\n")
cat("Mean of terminal prices (rescaled GBM):", mean(terminal_rescaled), "\n")
cat("Variance of terminal prices (normal GBM):", var(terminal_normal), "\n")
cat("Variance of terminal prices (rescaled GBM):", var(terminal_rescaled), "\n")
```

## Results
### Per Time Step
Step-wise comparison of sample means vs. theoretical means:
```r
Step | Time | Theoretical Mean | Normal GBM Mean | Normal Diff | Rescaled Mean | Rescaled Diff
------------------------------------------------------------------------------------
   0 | 0.00 | 100.0000         | 100.0000        | 0.0000    | 100.0000       | 0.0000
  25 | 0.25 | 101.2578         | 101.5298        | 0.2720    | 101.2578       | 0.0000
  50 | 0.50 | 102.5315         | 102.6828        | 0.1513    | 102.5315       | 0.0000
  75 | 0.75 | 103.8212         | 104.1133        | 0.2921    | 103.8212       | 0.0000
 100 | 1.00 | 105.1271         | 105.2550        | 0.1278    | 105.1271       | -0.0000
```
### Summary Statistics:
```r
> cat("Mean path volatility (normal GBM):", mean(vols_normal), "\n")
Mean path volatility (normal GBM): 0.1995901 

> cat("Mean path volatility (rescaled GBM):", mean(vols_rescaled), "\n")
Mean path volatility (rescaled GBM): 0.1996616 

> cat("Mean of terminal prices (normal GBM):", mean(terminal_normal), "\n")
Mean of terminal prices (normal GBM): 105.255 

> cat("Mean of terminal prices (rescaled GBM):", mean(terminal_rescaled), "\n")
Mean of terminal prices (rescaled GBM): 105.1271 

> cat("Variance of terminal prices (normal GBM):", var(terminal_normal), "\n")
Variance of terminal prices (normal GBM): 459.9805 

> cat("Variance of terminal prices (rescaled GBM):", var(terminal_rescaled), "\n")
Variance of terminal prices (rescaled GBM): 444.5976 
```

The results confirm that `NNS.rescale()` is a powerful tool for enforcing theoretical expectations in financial simulations. While unnecessary for ***perfectly calibrated*** GBMs, it becomes indispensable when:

   1. Drift terms are misspecified (e.g., using historical data).

   2. Exact mean alignment is critical (e.g., regulatory reporting).

   3. Computational constraints limit the number of paths.

By preserving volatility and terminal distributions, it bridges the gap between theoretical rigor and practical flexibility, making it a valuable addition to quantitative finance workflows.
