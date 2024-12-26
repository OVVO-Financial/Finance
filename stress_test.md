# Stress Testing 
Overview of stress testing procedure whereby analysis is restricted to the CLPM quadrant of returns and `NNS.reg()` is utilized to uphold multivariate dependence structure.

## Data
Assuming you have historical returns for securities of interest
```r
> head(Returns)
                    SPY          AAPL          MSFT         GOOGL          AMZN         META         TSLA         NVDA
2019-12-27 -0.000247777 -0.0003794828  0.0018277466 -0.0057468387  0.0005511477  0.001491953 -0.001299523 -0.009699417
2019-12-30 -0.005513222  0.0059351321 -0.0086185853 -0.0110214627 -0.0122526496 -0.017731871 -0.036432872 -0.019208845
2019-12-31  0.002429297  0.0073065483  0.0006980177 -0.0002388404  0.0005143848  0.004109370  0.008753267  0.012827149
2020-01-02  0.009351923  0.0228163199  0.0185161587  0.0218681710  0.0271506104  0.022070640  0.028518175  0.019591947
2020-01-03 -0.007572233 -0.0097220355 -0.0124517498 -0.0052313429 -0.0121390347 -0.005291260  0.029633258 -0.016005956
```

## Procedure
```r
library(NNS)

target <- 0  # 1 if using geometric returns
desired_output <- -0.1  # 10% drop in SPY
tolerance <- 0.01 # Tolerance for desired output
nn <- 1e6  # Number of random samples

# Create a subset where all variables in the data frame are below 0
clpm_observations <- Returns[apply(Returns, 1, function(row) all(row < target)), ]
qq <- nrow(clpm_observations)

original_regressors <- clpm_observations[, -1]

# Target variable
y <- clpm_observations[, 1]

# Generate bootstrapped replicates of each regressor
sampled_regressors <- apply(original_regressors, 2, function(i) 
  head(as.vector(NNS::NNS.meboot(as.vector(i), reps = ceiling(nn/qq), rho = 1)["replicates",]$replicates), nn))

# Optimal Clusters and predicted values
predicted_values <- NNS.stack(IVs.train = original_regressors, DV.train = y, 
                              IVs.test = sampled_regressors, method = 1)$stack

# Find the closest match to the desired output
differences <- abs(predicted_values - desired_output)
best_index <- which.min(differences)

# Optimal regressors and achieved output
optimal_regressors <- sampled_regressors[best_index, ]
optimal_output <- predicted_values[best_index]

# Identify regressors within the tolerance range
within_tolerance <- differences <= tolerance
filtered_regressors <- as.data.frame(sampled_regressors[within_tolerance, ])

# Average value for filtered regressors
expected_regressors <- apply(filtered_regressors, 2, function(i) mean(i))
num_regressors <- ncol(filtered_regressors)

# Plot histograms for each regressor
par(mfrow = c(ceiling(sqrt(num_regressors)), ceiling(sqrt(num_regressors))))  # Arrange plots in a grid

for (i in 1:num_regressors) {
  regressor_name <- colnames(filtered_regressors)[i]
  
  variable <- filtered_regressors[[regressor_name]]
  
  hist(variable, breaks = 30, col = adjustcolor("steelblue", alpha.f = 0.8),
       border = "white", main = paste("Loss Distribution of", regressor_name), 
       xlab = regressor_name, freq = FALSE)
  
  var_mean <- mean(variable)
  
  # Confidence Intervals
  lpm_var <- NNS::LPM.VaR(percentile = 0.025, degree = 0, x = variable)
  upm_var <- NNS::UPM.VaR(percentile = 0.025, degree = 0, x = variable)
  
  abline(v = var_mean, col = "red", lwd = 2)  # Mean
  abline(v = upm_var, col = "red", lwd = 2, lty = 2)  # UPM.VaR
  abline(v = lpm_var, col = "red", lwd = 2, lty = 2)  # LPM.VaR
  
  text(x = c(var_mean, lpm_var, upm_var), 
       y = 0, 
       labels = round(c(var_mean, lpm_var, upm_var), 2), 
       col = "red", pos = 3, cex = 2)
}

par(mfrow = c(1, 1))  # Reset plotting layout
```
## Results
```r
expected_regressors
       AAPL        MSFT       GOOGL        AMZN        META        TSLA        NVDA 
-0.12253002 -0.13652204 -0.11021472 -0.05533813 -0.15061686 -0.16932392 -0.17324354
```

<img src="Images/mag_7_loss_distributions.png" style="border: none; outline: none; margin: 0; padding: 0; display: block;"/>

