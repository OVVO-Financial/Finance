# Finance
Implementation of **PORTFOLIO THEORY** available at  http://ssrn.com/abstract=2791621 

##**Portfolio Theory Steps:**

**1.  Data Download:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Download data and create returns series via `quantmod` routines.  Outputs `Returns` and `Volume` data.frames for specified time frame.

**2.  Returns Conditioning:** <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Conditions `Returns` with entropy proxies.  Outputs `Conditioned` data.frame.<br />
S&P 100 Conditioning Run Time: <br />
`> system.time(conditioning(Sample.period,Backtest))`<br />
`user  system elapsed` <br />
`283.10    0.08  284.79` <br />
    
**3.  Optimization:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Non-convex `UPM/LPM` optimization of `Conditioned` data.frame.   See here for comparison of optimization methods: https://github.com/OVVO-Financial/Finance/blob/master/R/Optimization%20Method%20Comparison<br />
S&P 100 `UPM/LPM` Optimization Run Time: <br />
`>system.time(VN.opt(Conditioned))` <br />
 `user  system elapsed` <br /> 
 `216.86    0.31  233.38` <br /> 

##**Example on S&P 100 for 1 year holding period**<br />

**Optimized `Conditioned` data.frame**<br />
![SP100 Weights](https://github.com/OVVO-Financial/Finance/blob/master/Images/SP100%20Condtioned%20Weights%201%20year%20hold.png)

**Comparison vs. equal weight (1/N) and entropy conditioned optimized UPM/LPM portfolio**<br />
![SP100 Returns](https://github.com/OVVO-Financial/Finance/blob/master/Images/SP100%201%20Year%20Hold%20Period.png)
