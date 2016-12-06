# Finance
Implementation of **PORTFOLIO THEORY** available at  http://ssrn.com/abstract=2791621 

##**Portfolio Theory Steps:**

**1.  Data Download:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Download data and create returns series via `quantmod` routines.  Outputs `Returns` and `Volume` data.frames for specified time frame.

**2.  Returns Conditioning:** <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Conditions `Returns` with entropy proxies.  Outputs `Conditioned` data.frame.<br />

####S&P 100 Conditioning Run Time: <br />
```{r}
> system.time(Condition(Sample.period,Backtest))
user  system elapsed
283.10    0.08  284.79
```    
**3.  Optimization:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Non-convex `UPM/LPM` optimization of `Conditioned` data.frame.   See here for comparison of optimization methods: https://github.com/OVVO-Financial/Finance/blob/master/R/Optimization%20Method%20Comparison.md<br />

####S&P 100 `UPM/LPM` Optimization Run Time: <br />
```{r}
> system.time(VN.opt(Conditioned)) 
user  system elapsed 
216.86    0.31  233.38
```
##**Example on DJIA, 100 ETFs, and S&P 100 for 1 year holding period**<br />


**Comparison vs. equal weight (1/N) and S&P 500 benchmarks**<br />
![DJIA Returns](https://github.com/OVVO-Financial/Finance/blob/master/Images/DJIA.png)

![SP100 Returns](https://github.com/OVVO-Financial/Finance/blob/master/Images/SP100.png)

![ETFs Returns](https://github.com/OVVO-Financial/Finance/blob/master/Images/ETFs.png)
