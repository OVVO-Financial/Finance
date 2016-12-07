
# Instructions
```{r}
require(PerformanceAnalytics)
require(quantmod)
require(XML)
require(tseries)
require(NNS)
require(DEoptim)
```

#Step1: Create Symbol list
```{r}
  DJIA.Symbols <- c("AAPL","AXP","BA","CAT","CSCO","CVX","DD","DIS","GE","GS","HD","IBM","INTC","JNJ","JPM","KO","MCD","MMM","MRK","MSFT","NKE","PG","PFE","TRV","UNH","UTX","V","VZ","WMT","XOM")

  ETF.Symbols <- c("SPY","GLD","FXE","TLT","VXX") #...
```
#Step2: Download Data
```{r}
  Raw.Data(DJIA.Symbols,start.date="2013-01-01",end.date="2016-06-17")
```
      
#Step3: Condition Data  ### RUN ONCE RETURN 3 GLOBAL VARIABLES
```{r}
  Sample.period <<- 100; Backtest <<- 250;
  conditioning(Sample.period,Backtest);
  EW.port <- rowMeans(BT.Raw)
```
    
#Step4: Optimize Data & Portfolio Construction
```{r}
  LPM.degree <<- 3;UPM.degree<<- 2;
  LPM.target = 1.00005;UPM.target=1.00005;
  Conditioned.port=VN.opt(Conditioned);
  Conditioned.weights <<- Conditioned.port;

  UN.Conditioned.port=VN.opt(Raw);
  UN.Conditioned.weights <<- UN.Conditioned.port;
```  


#Step5: Plot portfolios
```{r}
  plotting()
```
