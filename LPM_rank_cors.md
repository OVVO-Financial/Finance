This script retrieves the most recent S&P 500 constituents and their price data, then calculates log returns. Using this information, we evaluate rank correlations across various risk metrics:
* Expected Regret of Drawdown `ERoD`
* Conditional Drawdown at Risk `CDaR`
* Conditional Value at Risk `CVaR` 
* Lower Partial Moments `LPM degrees 1:4`

```r
# Load necessary libraries
library(quantmod)
library(NNS)
library(rvest)

# Constants for risk measures
Q_LEVEL <- 0.1      # Quantile for CDaR and CVaR (10% worst drawdowns/returns)
THRESHOLD_Q <- 0.2  # Threshold for ERoD (epsilon)

# Function to fetch S&P 500 stock list from Wikipedia
fetch_sp500_tickers <- function() {
  # Define URLs (original and fallback)
  sp500_url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
  alternative_url <- "https://en.wikipedia.org/wiki/List_of_S_and_P_500_companies"
  
  # Attempt to fetch the table, with fallback if the original URL fails
  sp500_table <- tryCatch({
    read_html(sp500_url) %>% html_table(fill = TRUE)
  }, error = function(e) {
    message("Failed to fetch from original URL. Trying alternative URL...")
    read_html(alternative_url) %>% html_table(fill = TRUE)
  })
  
  # Extract tickers and clean them (replace periods with hyphens)
  tickers <- sp500_table[[1]]$Symbol
  tickers <- gsub("\\.", "-", tickers)
  
  return(tickers)
}

# Function to fetch stock price data with error handling
fetch_stock_data <- function(tickers, start_date = "2018-01-01", end_date = "2025-02-15") {
  # Fetch adjusted close prices for each ticker
  stock_data <- map(tickers, function(ticker) {
    tryCatch({
      data <- getSymbols(
        ticker, 
        src = "yahoo", 
        from = start_date, 
        to = end_date, 
        auto.assign = FALSE
      )[, 6]  # Use adjusted close (6th column)
      
      # Ensure minimum number of data points
      if (nrow(data) < 500) return(NA)
      return(data)
    }, error = function(e) NA)
  })
  
  # Filter out failed or NA results
  valid_indices <- which(!sapply(stock_data, function(x) is.null(x) || is.na(x)))
  if (length(valid_indices) == 0) {
    stop("No valid stock data retrieved. Check ticker list or data source.")
  }
  
  stock_data <- stock_data[valid_indices]
  tickers <- tickers[valid_indices]
  
  # Merge all stock data into a single xts object
  merged_data <- reduce(stock_data, merge)
  
  # Handle missing values: forward-fill and remove residual NAs
  merged_data <- na.locf(merged_data)
  merged_data <- na.omit(merged_data)
  
  # Assign column names (tickers)
  colnames(merged_data) <- tickers
  
  return(merged_data)
}

# Function to compute risk measures for a return series
compute_risk_measures <- function(ret) {
  # Compute cumulative log returns (ret is already log returns from ROC)
  cum_ret <- cumsum(ret)
  
  # Compute drawdowns
  drawdowns <- sapply(1:length(ret), function(t) max(cum_ret[1:t]) - cum_ret[t])
  
  # ERoD: Mean of drawdowns exceeding the threshold (epsilon)
  edor <- mean(pmax(drawdowns - THRESHOLD_Q, 0))
  
  # CDaR: Mean of the worst (1-q_level)% drawdowns
  cdar <- mean(sort(drawdowns, decreasing = TRUE)[1:floor(Q_LEVEL * length(drawdowns))])
  
  # CVaR: Mean of the worst (1-q_level)% returns (negative for losses)
  cvar_threshold <- quantile(ret, 1 - Q_LEVEL)  # 90th percentile (upper tail of returns)
  cvar <- -mean(ret[ret <= cvar_threshold])     # Flip negative returns to positive for ranking
  
  # LPMs: Lower Partial Moments
  gain_loss_thresh <- 0
  lpm1 <- LPM(1, gain_loss_thresh, ret)
  lpm2 <- LPM(2, gain_loss_thresh, ret)
  lpm3 <- LPM(3, gain_loss_thresh, ret)
  lpm4 <- LPM(4, gain_loss_thresh, ret)
  
  return(c(EDoR = edor, CDaR = cdar, CVaR = cvar, 
           LPM1 = lpm1, LPM2 = lpm2, LPM3 = lpm3, LPM4 = lpm4))
}

# Main execution
main <- function() {
  # Fetch S&P 500 tickers
  sp500_tickers <- fetch_sp500_tickers()
  
  # Fetch stock price data
  price_data <- fetch_stock_data(sp500_tickers)
  
  # Compute daily log returns
  returns <- ROC(price_data, type = "continuous")[-1, ] %>% na.omit()
  
  # Compute risk measures for each stock
  risk_matrix <- t(apply(returns, 2, compute_risk_measures))
  
  # Convert to data frame
  risk_df <- as.data.frame(risk_matrix)
  
  # Rank the measures
  rank_df <- risk_df %>% mutate_all(rank)
  
  # Compute Spearman rank correlations
  cor_matrix <- cor(rank_df, method = "spearman")
  
  # Display results
  print(cor_matrix)
}

# Run the script
main()
```

The results illustrate how higher degrees of lower partial moments amplify tail risk effects, aligning closely with the drawdown-focused measures `ERoD` and `CDaR`. 
Additionally, the connection between `CVaR` and a linear utility framework is evident through its relationship with `LPM degree 1`. 
Notably, as an investor’s risk aversion increases (*reflected in higher* `LPM` *degrees*) drawdown-based measures like `EDoR` and `CDaR` provide less distinct information, as the `LPM` focus shifts toward extreme tail losses rather than the magnitude or frequency of drawdowns alone.

```r
          EDoR      CDaR      CVaR      LPM1      LPM2      LPM3      LPM4
EDoR 1.0000000 0.9877608 0.8814864 0.7668398 0.7504878 0.7119337 0.6747384
CDaR 0.9877608 1.0000000 0.8891179 0.7719253 0.7547708 0.7139340 0.6744421
CVaR 0.8814864 0.8891179 1.0000000 0.8592282 0.7984393 0.7201233 0.6583978
LPM1 0.7668398 0.7719253 0.8592282 1.0000000 0.9515798 0.8551246 0.7785731
LPM2 0.7504878 0.7547708 0.7984393 0.9515798 1.0000000 0.9677166 0.9194050
LPM3 0.7119337 0.7139340 0.7201233 0.8551246 0.9677166 1.0000000 0.9872110
LPM4 0.6747384 0.6744421 0.6583978 0.7785731 0.9194050 0.9872110 1.0000000
```
