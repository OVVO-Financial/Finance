# Finance
Implementation of **PORTFOLIO THEORY** available at  http://ssrn.com/abstract=2791621


**Portfolio Theory Steps:**

**1.  Data Download:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Download data and create returns via `quantmod` routines.  Outputs `Returns` and `Volume` data.frames for specified time frame.

**2.  Returns Conditioning:** <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Conditions the returns with entropy proxies.  Outputs `Conditioned` data.frame.
    
**3.  Optimization:**  <br />
&nbsp;&nbsp;&nbsp;&nbsp;    Nonconvex `UPM/LPM` optimization of `Conditioned` data.frame. 
