# Finance Research Notes

This repository collects working papers, analytical notebooks, and reproducible code that explore [Nonlinear Nonparametric Statistics (NNS)](https://github.com/OVVO-Financial/NNS) tools for portfolio construction, risk management, and derivative pricing.

## Documents

### Distributional_Equivalence_in_GBM.pdf
Derives the Radon–Nikodym density that maps the physical measure to its risk-neutral counterpart when asset prices follow geometric Brownian motion. The note documents how drift adjustments, discounting, and martingale consistency emerge in closed form, providing a concise reference that complements the P and Q rescaling discussion.

- [Download the PDF](Distributional_Equivalence_in_GBM.pdf)

### NNS_MFE.md
A modern restatement of mathematical finance foundations through the lens of Nonlinear Nonparametric Statistics. The paper replaces parametric stochastic differential equation machinery with empirical distributions, partial-moment valuation, and pathwise risk-neutral rescaling to deliver a fully data-driven pricing and risk measurement pipeline that still respects martingale constraints.

- [Read the Markdown](NNS_MFE.md)
- [Download the PDF](NNS_MFE.pdf)

### LPM_rank_cors.md
Demonstrates how to source current S&P 500 constituents, compute log returns, and evaluate the concordance between tail-sensitive risk measures. The analysis contrasts expected regret of drawdown, conditional drawdown at risk, conditional value at risk, and lower partial moments to highlight ranking differences driven by asymmetry.

- [Read the Markdown](LPM_rank_cors.md)

### P_and_Q.md
Illustrates why `NNS.rescale()` is required when simulated price paths must satisfy theoretical expectations under different probability measures. The worked example shows how the function enforces risk-neutral and discounted constraints without distorting the empirical distribution.

- [Read the Markdown](P_and_Q.md)

### P_to_Q_NNS_rescale
Walks through the `P_to_Q_NNS_rescale.Rnw` reproducible research workflow that connects the theoretical discussion to the accompanying data-driven implementation. The dynamic document demonstrates how the rescaling procedure enforces discounted martingale constraints and links to the generated PDF output.

- [Inspect the Sweave source](P_to_Q_NNS_rescale.Rnw)
- [Download the compiled PDF](P_to_Q_NNS_rescale.pdf)

### SD_cluster.md
Compares stochastic dominance clustering with Hierarchical Risk Parity and naïve equal weighting in an out-of-sample asset allocation setting. The workflow extracts S&P 500 data, constructs NNS stochastic dominance clusters, and contrasts their performance with conventional portfolio construction heuristics.

- [Read the Markdown](SD_cluster.md)

### stress_test.md
Outlines a stress-testing framework that confines analysis to the downside co-lower partial moment quadrant while preserving nonlinear dependence through `NNS.reg()`. Bootstrapped replicates and dependence diagnostics ensure scenario paths respect empirical joint behavior when targeting adverse market moves.

- [Read the Markdown](stress_test.md)

## Additional Resources

- [NNS.options() accuracy comparison](https://htmlpreview.github.io/?https://github.com/OVVO-Financial/Finance/blob/master/NNS_Options_comparison.html)
- [View the HTML file directly in the repository](NNS_Options_comparison.html)
- Original portfolio theory implementation details: [SSRN abstract 2791621](http://ssrn.com/abstract=2791621) and [OVVO Labs](https://www.ovvolabs.com)
