# NNS as a Modern MFE: A Data-Driven Reconstruction of Stochastic Finance

**Author:** Fred Viole  
**Date:** October 12, 2025  

## Abstract
Modern Mathematical Finance and Economics (MFE) relies on stochastic differential equations (SDEs) to model asset price dynamics, enabling derivative valuation, risk measurement, and forecasting. These models typically impose parametric structures (e.g., log-normality, constant volatility) that are fragile under fat tails, skewness, and regime shifts. **Nonlinear Nonparametric Statistics (NNS)** reconstructs this ethos by starting with data, not equations: empirical distributions and partition-based learning replace parametric SDEs. Valuation becomes partial-moment integration over empirically simulated paths; risk uses asymmetric (co-)partial moments; forecasting leverages nonlinear partitions. Critically, NNS respects the constraints enforced by stochastic calculus—such as no-arbitrage and martingale properties—without requiring its formal machinery, treating it as a derivation tool rather than a necessity. Since real-world finance is inherently discrete (due to technological, regulatory, and human constraints on observables like ticks and sampling), NNS's empirical focus aligns naturally with practice.

To that end, we incorporate a *pathwise risk-neutral rescaling* that induces an empirical measure under which discounted prices are (in-sample) martingales and preserves static no-arbitrage shape properties. Coupled with partial-moment payoff integration, this produces an end-to-end, measure-consistent, nonparametric pipeline. We also outline a regime-spanning benchmarking protocol against parametric and constrained nonparametric competitors.

## The MFE Ethos
MFE aims to price fairly, measure risk, and make decisions. Under the risk-neutral measure \(\Q\), discounted prices are martingales and option values are discounted expectations:

\[ V(t,s)=\E_\Q\!\left[e^{-\int_t^T r(u)\,\dd u}\,h(S_T)\mid S_t=s\right]. \]

Risk under \(\PP\) quantifies uncertainty (volatility, covariance, tail risk). Classical tools (Black--Scholes, GARCH) impose restrictive forms; NNS instead learns from data, capturing nonlinearities and asymmetries without parametric constraints. Stochastic calculus serves as a derivation tool for these principles in continuous-time models, but it is not a requirement for pricing—empirical or simulation-based methods suffice if they respect the outputs, such as correct drifts and expected values under the relevant measures, without invoking Itô's lemma or similar syntax.

## MFE Tools and NNS Analogues

| **MFE Goal**          | **Purpose**              | **MFE Tool (Limitations)**                        | **NNS Analogue**                          |
|-----------------------|--------------------------|--------------------------------------------------|------------------------------------------|
| Model price dynamics  | Trend + randomness.      | SDEs (GBM): \(\dd S_t=\mu S_t \dd t + \sigma S_t \dd W_t\) (constant \(\sigma\), log-normality). | NNS regression: nonlinear empirical dynamics. |
| Change to risk-neutral measure | Enforce fair growth for pricing. | Girsanov (requires parametric drift/vol). | **Pathwise rescaling:** discounted-martingale means enforced empirically. |
| Price derivatives     | Compute fair values.     | Black--Scholes/Feynman--Kac (sensitive to skew/tails). | **Partial moments:** \(C_0=e^{-rT}\UPM_1(K;S_T^\ast)\). |
| Measure risk          | Quantify variability/comovement. | Covariance, GARCH (symmetry/parametric). | **(Co-)Partial moments:** asymmetric dependence (CUPM/CLPM/DUPM/DLPM). |
| Forecasting           | Predict states/volatility. | ARIMA/GARCH (linear/parametric). | NNS forecasting (ARMA/VAR) with seasonality detection. |

## Partial Moments as Primitives
Partial moments focus on targeted regions [Fishburn1977, BawaLindenberg1977]:

\[ \LPM{n}{t}{X}=\int_{-\infty}^t (t-x)^n \dd F_X(x),\quad \UPM{n}{t}{X}=\int_t^\infty (x-t)^n \dd F_X(x). \]

For \(n=2\) and \(t=\mu_X\): \(\Var(X)=\LPM{2}{\mu_X}{X}+\UPM{2}{\mu_X}{X}\). This exposes asymmetry (downside vs. upside). NNS computes these nonparametrically, avoiding Gaussian assumptions, and extends to co-partial structures for dependence.

## Simulation under \(\PP\) and the Risk-Neutral Bridge
Under \(\PP\), one may simulate with resampling or SDE proposals. Pricing requires \(\Q\) so that \(e^{-rt}S_t\) is a martingale. Instead of analytic Girsanov, we use an empirical analogue via **pathwise rescaling**. This respects the outputs of stochastic calculus (e.g., correct expected values) without its syntax, as simulations or empirical data satisfying these constraints align with theory even absent Itô's lemma.

Practically, finance operates in discrete time: price movements, trading, and data are discrete due to technological limits (e.g., tick sizes), regulatory constraints, and human factors. Even high-frequency data (e.g., nanosecond ticks) has finite resolution, rendering continuous assumptions approximations at best [Hasbrouck2007].

### Pathwise Risk-Neutral Rescaling
Let \(0=t_0<\dots<t_n=T\). After generating interim \(\widehat S_{t_k}^{(i)}\) under \(\PP\), define

\[ S_{t_k}^{*(i)}=\widehat S_{t_k}^{(i)}\cdot\frac{S_0 e^{r t_k}}{\overline{\widehat S}_{t_k}}, \qquad \overline{\widehat S}_{t_k}=\frac{1}{N}\sum_{i=1}^N \widehat S_{t_k}^{(i)}. \]

Initialize \(S_{t_0}^{*(i)}=S_0\) and iterate.

**Proposition (Empirical martingale condition):** For each grid time \(t_k\), \(\frac{1}{N}\sum_i e^{-r t_k}S_{t_k}^{*(i)}=S_0\). Hence \(e^{-rt}S_t^\ast\) is an in-sample martingale in expectation under the empirical measure induced by the rescaled paths.

*Proof:* By construction, \(\frac{1}{N}\sum_i S_{t_k}^{*(i)}=S_0 e^{r t_k}\). Multiply by \(e^{-r t_k}\).

**Remark:** This "in-sample martingale" property is the finite-sample, empirical analogue to the continuous-time martingale condition under \(\Q\), explicitly tying the method back to classical theory while accommodating discrete data.

**Lemma (Static no-arbitrage preserved):** Positive scalar maps \(x\mapsto c x\) preserve order and convexity. Therefore, empirical call prices \(K\mapsto e^{-rT}\UPM(1,K;S_T^\ast)\) remain convex in \(K\) and nondecreasing in \(S_0\) and \(r\).

**Diagnostics:** Check flat discounted means and near-zero autocorrelation of increments of \(e^{-rt}S_t^\ast\) (e.g., Ljung–Box).

**Runnable example (dynamic rescaling):**

```r
S0    <- 100; r <- 0.05; T <- 1; sigma <- 0.2
n     <- 100; dt <- T/n; N <- 10000
drift <- (r - 0.5*sigma^2)*dt; vol <- sigma*sqrt(dt)

# Reference: risk-neutral GBM
S_gbm <- matrix(NA_real_, n+1, N); S_gbm[1,] <- S0
for (k in 1:n) {
  z <- rnorm(N, drift, vol)
  S_gbm[k+1,] <- S_gbm[k,]*exp(z)
}

# Pathwise rescaling of P-world draws (drift can be misspecified)
S_star <- matrix(NA_real_, n+1, N); S_star[1,] <- S0
for (k in 1:n) {
  z <- rnorm(N, drift, vol)
  S_hat <- S_star[k,]*exp(z)
  target <- S0*exp(r*(k*dt))
  S_star[k+1,] <- S_hat * target/mean(S_hat)
}

# Diagnostics
tgrid   <- seq(0, T, by = dt)
mu_th   <- S0*exp(r*tgrid)
mu_gbm  <- rowMeans(S_gbm)
mu_star <- rowMeans(S_star)

rbind(
  c(time=tgrid[1],   th=mu_th[1],   gbm=mu_gbm[1],   star=mu_star[1]),
  c(time=tgrid[26],  th=mu_th[26],  gbm=mu_gbm[26],  star=mu_star[26]),
  c(time=tgrid[51],  th=mu_th[51],  gbm=mu_gbm[51],  star=mu_star[51]),
  c(time=tgrid[76],  th=mu_th[76],  gbm=mu_gbm[76],  star=mu_star[76]),
  c(time=tgrid[101], th=mu_th[101], gbm=mu_gbm[101], star=mu_star[101])
)
```
Intermediate steps output:
```r
     time     th      gbm     star
[1,] 0.00 100.0000 100.0000 100.0000
[2,] 0.25 101.2578 101.5298 101.2578
[3,] 0.50 102.5315 102.6828 102.5315
[4,] 0.75 103.8212 104.1133 103.8212
[5,] 1.00 105.1271 105.2550 105.1271
```

Terminal condition output:
```
c(mean_gbm=mean(S_gbm[n+1,]), mean_star=mean(S_star[n+1,]),
  var_gbm=var(S_gbm[n+1,]),  var_star=var(S_star[n+1,]))

mean_gbm mean_star var_gbm var_star
105.2550 105.1271 459.9805 444.5976
```

## Valuation by Partial-Moment Integration
Classically, a call price is \(C_0=e^{-rT}\E_\Q[(S_T-K)^+]\) [BlackScholes1973]. With pathwise rescaled terminal samples \(S_T^\ast\),

\[ C_0=e^{-rT}\,\UPM{1}{K}{S_T^\ast},\qquad P_0=e^{-rT}\,\LPM{1}{K}{S_T^\ast}. \]

Because rescaling is a positive scalar transformation, the convexity of \(K\mapsto (x-K)^+\) carries to empirical averages, preserving static no-arbitrage.

## Risk under \(\PP\): Asymmetry and Co-Partial Structure
Variance/covariance treat gains and losses symmetrically. NNS employs \(\LPM\) and \(\UPM\) (and their co-variants) to isolate tail/side-specific risk and dependence. The four quadrants (CUPM/CLPM/DUPM/DLPM) reveal asymmetric co-movement (e.g., co-crashes), informing hedging and capital allocation beyond correlation or Gaussian copulas [AngEtAl2006].

## Forecasting and Term Structures without Parametric SDEs
Partition-based forecasting captures nonlinearities and seasonality directly from data. Term structures (e.g., yields) arise from stacking such regressions across maturities, avoiding imposed functional forms.

## End-to-End NNS Pipeline
1. **Dynamics under \(\PP\):** learn empirical behavior via resampling or nonlinear regression.
2. **Simulation:** generate paths preserving real-world features.
3. **Risk-neutral enforcement:** *apply pathwise rescaling* so discounted means are flat (empirical martingale).
4. **Valuation:** integrate payoffs via partial moments on \(S_T^\ast\).
5. **Risk:** quantify asymmetry and co-crash using (co-)partial moments.
6. **Forecasting:** predict with NNS forecasting.


## Conclusion
NNS treats data as the solved process: empirical simulation, pathwise risk-neutral rescaling (ensuring in-sample martingale discounted prices), partial-moment valuation, and asymmetric risk. This produces a coherent, nonparametric alternative to parametric SDE finance, respecting theoretical constraints without stochastic calculus's machinery. Given finance's discrete nature, NNS aligns empirical practice with theory's outputs.


![NNS as a Modern MFE](https://github.com/OVVO-Financial/Finance/blob/main/Images/NNS_MFE.png?raw=true)


## References
- [AitSahaliaLo1998] Aït-Sahalia, Y., and Lo, A. W. (1998). Nonparametric estimation of state-price densities implicit in financial asset prices. *The Journal of Finance*, 53(2), 499–547.
- [AngEtAl2006] Ang, A., Chen, J., and Xing, Y. (2006). Downside risk. *The Review of Financial Studies*, 19(4), 1191–1239.
- [BawaLindenberg1977] Bawa, V. S., and Lindenberg, E. B. (1977). Capital market equilibrium in a mean-lower partial moment framework. *Journal of Financial Economics*, 5(2), 189–200.
- [BlackScholes1973] Black, F., and Scholes, M. (1973). The pricing of options and corporate liabilities. *Journal of Political Economy*, 81(3), 637–654.
- [Dupire1994] Dupire, B. (1994). Pricing with a smile. *Risk*, 7(1), 18–20.
- [Fishburn1977] Fishburn, P. C. (1977). Mean-risk analysis with risk associated with below-target returns. *The American Economic Review*, 67(2), 116–126.
- [Hasbrouck2007] Hasbrouck, J. (2007). *Empirical Market Microstructure: The Institutions, Economics, and Econometrics of Securities Trading*. Oxford University Press.
- [Heston1993] Heston, S. L. (1993). A closed-form solution for options with stochastic volatility with applications to bond and currency options. *The Review of Financial Studies*, 6(2), 327–343.
