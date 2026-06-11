# Finance Research Notes

This repository collects working papers, Markdown research notes, R/Sweave examples, PDFs, and supporting artifacts that explore [Nonlinear Nonparametric Statistics (NNS)](https://github.com/OVVO-Financial/NNS) tools for portfolio construction, risk management, derivative pricing, stochastic dominance, and directional PCA attribution.

## Documents

### Conditional Tail Dynamics via Put–Call IV Ratio
This study examines how option-implied volatility regimes govern the geometry of conditional forward return distributions following large price shocks. Using nonparametric tail statistics (Value at Risk, Expected Shortfall, and kurtosis) and near-dated option-implied volatilities, we analyze the Put–Call IV ratio as a state variable that selects tail structure—distinguishing between bilateral explosive risk, asymmetric recovery, and bounded near-Gaussian behavior across assets and horizons.

- [Download the PDF](Put_Call_IVs.pdf)

### Distributional Equivalence in GBM
Derives the Radon–Nikodym density that maps the physical measure to its risk-neutral counterpart when asset prices follow geometric Brownian motion. The note documents how drift adjustments, discounting, and martingale consistency emerge in closed form, providing a concise reference that complements the P and Q rescaling discussion.

- [Download the PDF](Distributional_Equivalence_in_GBM.pdf)

### Directional Markov Regimes and PCA Recovery
Extends NNS directional spectral decomposition from static partial-moment quadrants to time-indexed directional regimes. The note shows how observable quadrant frequencies, conditional means, transition paths, and partial-moment matrices recover covariance and attribute PCA eigenvalues without relying on hidden-state labels.

- [Read the Markdown](directional-markov-regimes-pca-pm-matrix-updated.md)

### Exogenous Directional Risk Matrices
Companion PDF note on directional risk-matrix construction and interpretation for exogenous market or factor inputs.

- [Download the PDF](exogenous_directional_risk_matrices_note.pdf)

### LPM rank correlations
Demonstrates how to source current S&P 500 constituents, compute log returns, and evaluate the concordance between tail-sensitive risk measures. The analysis contrasts expected regret of drawdown, conditional drawdown at risk, conditional value at risk, and lower partial moments to highlight ranking differences driven by asymmetry.

- [Read the Markdown](LPM_rank_cors.md)

### NNS_MFE
A modern restatement of mathematical finance foundations through the lens of Nonlinear Nonparametric Statistics. The paper replaces parametric stochastic differential equation machinery with empirical distributions, partial-moment valuation, and pathwise risk-neutral rescaling to deliver a fully data-driven pricing and risk measurement pipeline that still respects martingale constraints.

- [Read the Markdown](NNS_MFE.md)
- [Download the PDF](NNS_MFE.pdf)

### NNS Directional Spectral Decomposition
Develops a directional genealogy for covariance and PCA using full mean-split orthants, pairwise partial-moment matrices, and scalable `DPM_nD` diagnostics. The note distinguishes exact spectral recovery from compact directional summaries for high-dimensional applications.

- [Read the Markdown](nns-directional-spectral-decomposition.md)

### Omega Computation and Critique (Markowitz 2012)
Presents a parametric linear programming (PLP) framework for tracing the complete set of Ω(L)-maximizing portfolios across admissible thresholds L, replacing discrete optimization with a continuous frontier analysis. The paper shows that maximizing Ω(L) is equivalent to achieving expected return and lower partial moment efficiency, and formalizes the simplex-based transition rules governing basis changes as L varies. It then critiques Ω as a performance criterion, contrasting it with stochastic dominance and expected-utility theory, and surveys empirical evidence indicating that mean-variance approximations often outperform VaR, CVaR, MAD, and related downside measures in approximating expected utility.

- [Download the DOCX](Omega-Computation-and-Critique-Markowitz-2012.docx)

### P_and_Q
Illustrates why `NNS.rescale()` is required when simulated price paths must satisfy theoretical expectations under different probability measures. The worked example shows how the function enforces risk-neutral and discounted constraints without distorting the empirical distribution.

- [Read the Markdown](P_and_Q.md)

### P_to_Q_NNS_rescale
Walks through the `P_to_Q_NNS_rescale.Rnw` reproducible research workflow that connects the theoretical discussion to the accompanying data-driven implementation. The dynamic document demonstrates how the rescaling procedure enforces discounted martingale constraints and links to the generated PDF output.

- [Inspect the Sweave source](P_to_Q_NNS_rescale.Rnw)
- [Download the compiled PDF](P_to_Q_NNS_rescale.pdf)

### SD_cluster
Compares stochastic dominance clustering with Hierarchical Risk Parity and naïve equal weighting in an out-of-sample asset allocation setting. The workflow extracts S&P 500 data, constructs NNS stochastic dominance clusters, and contrasts their performance with conventional portfolio construction heuristics.

- [Read the Markdown](SD_cluster.md)

### Stress Testing
Outlines a stress-testing framework that confines analysis to the downside co-lower partial moment quadrant while preserving nonlinear dependence through `NNS.reg()`. Bootstrapped replicates and dependence diagnostics ensure scenario paths respect empirical joint behavior when targeting adverse market moves.

- [Read the Markdown](stress_test.md)

### PT as I Still See It
Harry M. Markowitz's 2010 Annual Review of Financial Economics article revisiting portfolio theory, including the roles of mean-variance analysis, expected utility, and practical portfolio-selection assumptions.

- [Download the PDF](PT%20as%20I%20still%20see%20it.pdf)

### Nine Criticisms, Nine Concessions
Catalogs nine criticisms of partial-moment methods and pairs them with nine concessions, clarifying the limits, tradeoffs, and appropriate interpretation of partial moments in risk and utility analysis.

- [Download the PDF](Nine_criticisms_nine_concessions.pdf)

### Peters Ergodicity Critique
Critical literature review of Ole Peters and ergodicity economics, focusing on time-average versus ensemble-average reasoning, multiplicative wealth dynamics, and how those claims interact with expected utility and partial-moment analysis.

- [Download the PDF](Peters_ergodocity_critique.pdf)

### Utility Theory with Partial Moments
Synthesizes a trilogy of utility-theory papers into a unified partial-moments framework. The note develops utility from dual benchmarks using upper and lower partial moments, explains how benchmark heterogeneity affects zero-return utility, and connects the framework to behavioral phenomena such as loss aversion, the house money effect, and the break-even effect. It also highlights practical applications in portfolio optimization and asymmetric risk assessment.

- [Download the PDF](Utility%20Theory%20with%20Partial%20Moments.pdf)

### When PC1 Is Not the Market Factor
Demonstrates that the first principal component can represent a dominant spread factor rather than a broad market factor. The simulation uses NNS mean-split orthants to recover the PCA eigensystem and attribute the leading variance axis to the directional regimes that generated it.

- [Read the Markdown](when-pc1-is-not-the-market-factor.md)

## Data and Replication Notes

### Estimation Error Replication
Companion notes for reproducing estimation-error experiments and implementation details used in portfolio comparison exercises.

- [Read the Markdown](Data/Estimation_Error_Replication.md)

### Put Call IV Results
Appendix-style results tables supporting the Put–Call IV tail-dynamics study, including lagged tail-statistic summaries across assets and put-call IV regime splits.

- [Read the results tables](Data/Put%20Call%20IV%20Results)

## Additional Resources

- [NNS.options() accuracy comparison](NNS_Options_comparison.html) ([HTML preview](https://htmlpreview.github.io/?https://github.com/OVVO-Financial/Finance/blob/master/NNS_Options_comparison.html))
- Original portfolio theory implementation details: [SSRN abstract 2791621](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2791621) and [OVVO Labs](https://www.ovvolabs.com) 
