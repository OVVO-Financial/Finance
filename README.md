# Finance
Implementation of **PORTFOLIO THEORY** available at  http://ssrn.com/abstract=2791621 

##**Portfolio Theory Steps:**

**1.  Data Download:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Download data and create returns via `quantmod` routines.  Outputs `Returns` and `Volume` data.frames for specified time frame.

**2.  Returns Conditioning:** <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Conditions the returns with entropy proxies.  Outputs `Conditioned` data.frame.<br />
S&P 100 Conditioning Run Time: <br />
`> system.time(conditioning(Sample.period,Backtest))`<br />
`user  system elapsed` <br />
`283.10    0.08  284.79` <br />
    
**3.  Optimization:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Non-convex `UPM/LPM` optimization of `Conditioned` data.frame. <br />
S&P 100 `UPM/LPM` Optimization Run Time: <br />
`>system.time(VN.Lin.opt(Conditioned))` <br />
 `user  system elapsed` <br /> 
 `216.86    0.31  233.38` <br /> 

##**Example on S&P 100 for 3 month holding period**<br />

**Optimized `Conditioned` data.frame**<br />
![My image](https://github.com/OVVO-Financial/Finance/blob/master/Images/SP100%20Conditioned%20Weights%203%20months.png)

**Comparison vs. equal weight (1/N) and un-conditioned optimized UPM/LPM portfolio**<br />
![My image](https://github.com/OVVO-Financial/Finance/blob/master/Images/SP100%203%20month%20holding%20period.png)
