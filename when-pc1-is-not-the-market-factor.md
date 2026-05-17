# When PC1 is Not the Market Factor

This example demonstrates an important point for PCA interpretation:

> PC1 is not always the market factor.

In this simulation, the first principal component is deliberately constructed to be a **spread factor**: assets 1 and 2 move together against assets 3, 4, and 5. The simple market factor, where all assets move together with the same sign, appears as PC2.

The NNS directional spectral decomposition still recovers the full PCA eigensystem exactly. More importantly, it identifies the **orthant regimes** that create PC1.

The conclusion is:

> PCA says PC1 is the dominant variance axis.  
> NNS says which directional regimes created that axis.

---

## 1. Core Idea

Classical PCA diagonalizes the covariance matrix. It reports eigenvalues and eigenvectors, but it does not explain which directional regions of the data produced those eigenvectors.

NNS directional decomposition begins with observable mean-split orthants. For five variables, each observation falls into one of:

```math
2^5 = 32
```

orthants.

Each orthant has:

- empirical probability `p_r`;
- conditional mean `m_r`;
- centered displacement `u_r = m_r - mu`;
- within-orthant covariance `Sigma_r`.

The covariance matrix decomposes as:

```math
\Sigma
=
\Sigma_B+\Sigma_W
```

where:

```math
\Sigma_B
=
\sum_r p_r u_r u_r^\top
```

and:

```math
\Sigma_W
=
\sum_r p_r\Sigma_r.
```

Each orthant contributes a rank-one spectral primitive:

```math
B_r = p_r u_r u_r^\top.
```

If `u_r` is nonzero, then:

```math
B_r u_r
=
p_r\|u_r\|^2u_r.
```

Thus each orthant conditional mean displacement is the nonzero eigenvector of its own rank-one contribution.

The full PCA eigensystem is recovered by:

```math
\{p_r,m_r,\Sigma_r\}_r
\longrightarrow
\Sigma_B+\Sigma_W
\longrightarrow
\Sigma
\longrightarrow
(\lambda_i,v_i).
```

---

## 2. Data Generating Process

The example uses five synthetic assets.

There are two orthogonal factors:

1. a simple market factor;
2. a stronger spread factor.

The market vector is:

```math
m =
(0.447,\;0.447,\;0.447,\;0.447,\;0.447).
```

The spread vector is:

```math
s =
(0.548,\;0.548,\;-0.365,\;-0.365,\;-0.365).
```

The spread vector is orthogonal to the market vector:

```math
m^\top s = 0.
```

The simulated data are generated from:

```math
Z
=
\sigma_m M m^\top
+
\sigma_s S s^\top
+
\sigma_e E,
```

where:

```math
\sigma_m = 0.70,
\qquad
\sigma_s = 1.80,
\qquad
\sigma_e = 0.30.
```

Because the spread factor is much stronger than the market factor, PC1 should be the spread factor, not the market factor.

---

## 3. Classical PCA Result

The PCA eigenvalues were:

| Component | Eigenvalue |
|---:|---:|
| PC1 | 3.369087 |
| PC2 | 0.578465 |
| PC3 | 0.094383 |
| PC4 | 0.089666 |
| PC5 | 0.088161 |

The first two eigenvectors were:

| Asset | PC1 | PC2 |
|---|---:|---:|
| Asset1 | -0.549037 | -0.446634 |
| Asset2 | -0.552728 | -0.439993 |
| Asset3 | 0.362994 | -0.452535 |
| Asset4 | 0.362294 | -0.449426 |
| Asset5 | 0.360593 | -0.447384 |

After sign alignment, PC1 is:

```math
(0.549037,\;0.552728,\;-0.362994,\;-0.362294,\;-0.360593).
```

PC2 is:

```math
(0.446634,\;0.439993,\;0.452535,\;0.449426,\;0.447384).
```

The alignment diagnostics were:

| Quantity | Value |
|---|---:|
| `abs(<PC1, market>)` | 0.007104 |
| `abs(<PC1, spread>)` | 0.999970 |
| `abs(<PC2, market>)` | 0.999957 |
| `abs(<PC2, spread>)` | 0.007085 |

So PC1 is essentially a pure spread factor, while PC2 is essentially the market factor.

This is the first key result:

> PC1 is not the market factor.

---

## 4. NNS Mean-Split Orthants

Each of the five assets is split at its mean. Every observation is assigned to an orthant according to whether each asset is above or below its component mean.

The run occupied all 32 orthants:

```math
\text{occupied orthants} = 32 \text{ out of } 32.
```

The two most important spread orthants are:

```text
Asset1+ Asset2+ Asset3- Asset4- Asset5-
```

and:

```text
Asset1- Asset2- Asset3+ Asset4+ Asset5+
```

These are the two opposite spread regimes.

---

## 5. Covariance Recovery

The NNS decomposition recovered the covariance matrix exactly to floating-point precision.

The max absolute difference between the original covariance and the recovered covariance was:

```math
3.219647\times 10^{-15}.
```

The equality check was:

```text
TRUE
```

So:

```math
\Sigma
=
\Sigma_B+\Sigma_W
```

holds numerically to machine precision.

---

## 6. PCA Recovery from NNS Decomposition

The original eigenvalues were:

```math
(3.36908712,\;0.57846528,\;0.09438324,\;0.08966572,\;0.08816072).
```

The recovered eigenvalues were identical:

```math
(3.36908712,\;0.57846528,\;0.09438324,\;0.08966572,\;0.08816072).
```

The eigenvalue differences were:

```math
(0,\;0,\;0,\;0,\;0).
```

The maximum absolute eigenvector difference after sign alignment was:

```math
1.451173\times 10^{-12}.
```

This is the second key result:

> NNS recovers the full PCA eigensystem even when PC1 is not the market factor.

---

## 7. Between-Orthant Eigensystem

The leading eigenvector of the between-orthant covariance `Sigma_B` was:

```math
(0.534144,\;0.539257,\;-0.376720,\;-0.376017,\;-0.374948).
```

Its alignment with the simple market factor was:

```math
0.024276.
```

Its alignment with the spread factor was:

```math
0.999698.
```

Its alignment with the full covariance PC1 was:

```math
0.999507.
```

This is the third key result:

> The conditional mean geometry alone nearly recovers the spread PC1.

---

## 8. Eigenvalue Attribution

Each eigenvalue decomposes into a between-orthant component and a within-orthant residual component.

For unit eigenvector `v_i`:

```math
\lambda_i
=
v_i^\top\Sigma_B v_i
+
v_i^\top\Sigma_W v_i.
```

Equivalently:

```math
\lambda_i
=
\sum_r p_r(v_i^\top u_r)^2
+
\sum_r p_r v_i^\top\Sigma_r v_i.
```

The attribution table was:

| Component | Eigenvalue | Between | Within | Total | Between Percent |
|---:|---:|---:|---:|---:|---:|
| PC1 | 3.369087 | 2.686913 | 0.682174 | 3.369087 | 79.75195 |
| PC2 | 0.578465 | 0.288031 | 0.290435 | 0.578465 | 49.79222 |
| PC3 | 0.094383 | 0.026586 | 0.067797 | 0.094383 | 28.16789 |
| PC4 | 0.089666 | 0.023741 | 0.065924 | 0.089666 | 26.47756 |
| PC5 | 0.088161 | 0.017964 | 0.070197 | 0.088161 | 20.37591 |

For PC1:

```math
\frac{2.686913}{3.369087}
=
0.7975195.
```

So about 79.8 percent of PC1 comes from between-orthant conditional mean displacement.

This is the fourth key result:

> PC1 is mostly an orthant conditional-mean separation, not residual within-orthant scatter.

---

## 9. Orthant-Level Attribution of PC1

The top ten orthant contributions to PC1 were:

| Rank | Orthant | Pattern | Probability | Contribution | Percent of PC1 |
|---:|---:|---|---:|---:|---:|
| 1 | 28 | Asset1- Asset2- Asset3+ Asset4+ Asset5+ | 0.2762 | 1.238090 | 36.748527 |
| 2 | 3 | Asset1+ Asset2+ Asset3- Asset4- Asset5- | 0.2730 | 1.232238 | 36.574837 |
| 3 | 24 | Asset1- Asset2- Asset3- Asset4+ Asset5+ | 0.0213 | 0.026420 | 0.784181 |
| 4 | 7 | Asset1+ Asset2+ Asset3+ Asset4- Asset5- | 0.0242 | 0.025185 | 0.747546 |
| 5 | 11 | Asset1+ Asset2+ Asset3- Asset4+ Asset5- | 0.0215 | 0.024507 | 0.727406 |
| 6 | 12 | Asset1- Asset2- Asset3+ Asset4+ Asset5- | 0.0200 | 0.022733 | 0.674759 |
| 7 | 19 | Asset1+ Asset2+ Asset3- Asset4- Asset5+ | 0.0201 | 0.020134 | 0.597600 |
| 8 | 20 | Asset1- Asset2- Asset3+ Asset4- Asset5+ | 0.0188 | 0.019444 | 0.577122 |
| 9 | 30 | Asset1- Asset2+ Asset3+ Asset4+ Asset5+ | 0.0207 | 0.009785 | 0.290429 |
| 10 | 2 | Asset1- Asset2+ Asset3- Asset4- Asset5- | 0.0219 | 0.009326 | 0.276817 |

The top two orthants alone contributed:

```math
36.748527\% + 36.574837\%
=
73.323364\%.
```

These are exactly the two opposite spread regimes:

```text
Asset1- Asset2- Asset3+ Asset4+ Asset5+
```

and:

```text
Asset1+ Asset2+ Asset3- Asset4- Asset5-
```

So PC1 is not merely a spread eigenvector in the abstract. NNS identifies the two directional regimes that create it.

This is the fifth key result:

> The dominant PCA axis is created by the two opposite spread orthants.

---

## 10. Why This Matters

This example is stronger than the simple market-factor case.

In the market-factor example, PC1 is the all-assets-up factor. That is intuitive and familiar.

Here, PC1 is not market beta. It is a long-short spread:

```math
(+,+,-,-,-)
```

versus:

```math
(-,-,+,+,+).
```

Classical PCA reports the eigenvector.

NNS reports the conditional regimes that created it.

That difference matters for interpretation, hedging, and portfolio construction.

---

## 11. Portfolio Interpretation

If PC1 were a market factor, a PC1 hedge would be close to a beta hedge.

But here PC1 is a spread factor. A hedge against PC1 is not a market hedge. It is a hedge against the directional spread regime:

```text
Assets 1 and 2 versus Assets 3, 4, and 5.
```

Classical PCA gives:

```math
w^\top v_1 = 0.
```

NNS gives a regime-level interpretation:

```math
w^\top u_r = 0
```

for the dominant spread orthants.

The top two orthants show exactly which stress regimes drive the axis:

```text
Asset1+ Asset2+ Asset3- Asset4- Asset5-
```

and:

```text
Asset1- Asset2- Asset3+ Asset4+ Asset5+
```

That turns an abstract eigenvector into named directional exposures.

---

## 12. Bottom Line

This example demonstrates:

1. PC1 is not always the market factor.
2. NNS still recovers the full PCA eigensystem exactly.
3. The between-orthant conditional mean geometry nearly recovers PC1 by itself.
4. About 80 percent of PC1 comes from between-orthant conditional mean displacement.
5. The top two orthants explain more than 73 percent of PC1.
6. Those top orthants are the two opposite spread regimes.

The clean summary is:

> PCA finds the spread axis.  
> NNS identifies the spread regimes that created it.

---

## Full R Code

```r
# =============================================================================
# NNS Spectral Decomposition When PC1 Is NOT the Market Factor
# =============================================================================

set.seed(2026)

n <- 10000
d <- 5

asset_names <- paste0("Asset", 1:d)

# -----------------------------------------------------------------------------
# 1. Construct factors
# -----------------------------------------------------------------------------

# Simple market direction: all assets move together
market <- rep(1, d)
market <- market / sqrt(sum(market^2))

# Spread direction: assets 1 and 2 versus assets 3, 4, and 5
# This is zero-sum, so it is orthogonal to the simple market vector.
spread_raw <- c(1, 1, -2/3, -2/3, -2/3)
spread <- spread_raw / sqrt(sum(spread_raw^2))

cat("Market vector:\n")
print(round(market, 6))

cat("\nSpread vector:\n")
print(round(spread, 6))

cat("\nMarket-spread inner product, should be near 0:\n")
print(sum(market * spread))

# Factor strengths
sd_market <- 0.70
sd_spread <- 1.80
sd_noise  <- 0.30

M <- rnorm(n)
S <- rnorm(n)
E <- matrix(rnorm(n * d), n, d)

Z <- sd_market * M %*% t(market) +
     sd_spread * S %*% t(spread) +
     sd_noise  * E

colnames(Z) <- asset_names

# -----------------------------------------------------------------------------
# 2. Classical PCA
# -----------------------------------------------------------------------------

mu <- colMeans(Z)
Zc <- sweep(Z, 2, mu)
Sigma <- crossprod(Zc) / n

pca <- eigen(Sigma)

cat("\n============================================================\n")
cat("CLASSICAL PCA\n")
cat("============================================================\n")

cat("\nEigenvalues:\n")
print(round(pca$values, 6))

cat("\nEigenvectors, first two columns:\n")
print(round(pca$vectors[, 1:2], 6))

v1 <- pca$vectors[, 1]
v2 <- pca$vectors[, 2]

# Align signs for easier interpretation
if (sum(v1 * spread) < 0) v1 <- -v1
if (sum(v2 * market) < 0) v2 <- -v2

cat("\nPC1 after sign alignment:\n")
print(round(v1, 6))

cat("\nPC2 after sign alignment:\n")
print(round(v2, 6))

cat("\nAbsolute alignment of PC1 with simple market factor:\n")
print(abs(sum(v1 * market)))

cat("\nAbsolute alignment of PC1 with spread factor:\n")
print(abs(sum(v1 * spread)))

cat("\nAbsolute alignment of PC2 with simple market factor:\n")
print(abs(sum(v2 * market)))

cat("\nAbsolute alignment of PC2 with spread factor:\n")
print(abs(sum(v2 * spread)))

cat("\nInterpretation:\n")
cat("  PC1 is the spread factor if alignment with spread is high and\n")
cat("  alignment with the simple market factor is low.\n")

# -----------------------------------------------------------------------------
# 3. NNS mean-split orthant partition
# -----------------------------------------------------------------------------

above_mean <- sweep(Z, 2, mu, ">")

orthant_label <- apply(above_mean, 1, function(row) {
  sum(row * 2^(0:(d - 1)))
})

n_orthants <- length(unique(orthant_label))

cat("\n============================================================\n")
cat("NNS MEAN-SPLIT ORTHANTS\n")
cat("============================================================\n")

cat("\nNumber of occupied orthants:", n_orthants, "out of", 2^d, "\n")

decode_orthant <- function(label, d, names_vec) {
  bits <- as.integer(intToBits(as.integer(label)))[1:d]
  signs <- ifelse(bits == 1, "+", "-")
  paste(paste0(names_vec, signs), collapse = " ")
}

# -----------------------------------------------------------------------------
# 4. Between-orthant and within-orthant decomposition
# -----------------------------------------------------------------------------

Sigma_B <- matrix(0, d, d)
Sigma_W <- matrix(0, d, d)

orthant_info <- data.frame(
  orthant = integer(),
  pattern = character(),
  p = numeric(),
  u_norm = numeric(),
  ell_rank1 = numeric(),
  stringsAsFactors = FALSE
)

for (lab in sort(unique(orthant_label))) {
  mask <- orthant_label == lab
  n_r <- sum(mask)
  p_r <- n_r / n

  Zr <- Z[mask, , drop = FALSE]
  m_r <- colMeans(Zr)
  u_r <- m_r - mu

  Cov_r <- crossprod(sweep(Zr, 2, m_r)) / n_r

  B_r <- p_r * tcrossprod(u_r)
  W_r <- p_r * Cov_r

  Sigma_B <- Sigma_B + B_r
  Sigma_W <- Sigma_W + W_r

  ell_r <- p_r * sum(u_r^2)

  orthant_info <- rbind(
    orthant_info,
    data.frame(
      orthant = lab,
      pattern = decode_orthant(lab, d, asset_names),
      p = p_r,
      u_norm = sqrt(sum(u_r^2)),
      ell_rank1 = ell_r,
      stringsAsFactors = FALSE
    )
  )
}

Sigma_rec <- Sigma_B + Sigma_W

cat("\n============================================================\n")
cat("COVARIANCE RECOVERY\n")
cat("============================================================\n")

cat("\nMax absolute difference between Sigma and Sigma_B + Sigma_W:\n")
print(max(abs(Sigma - Sigma_rec)))

cat("\nAre they identical to tolerance 1e-12?\n")
print(all.equal(Sigma, Sigma_rec, tolerance = 1e-12))

# -----------------------------------------------------------------------------
# 5. Recover PCA from NNS decomposition
# -----------------------------------------------------------------------------

pca_rec <- eigen(Sigma_rec)

# Align recovered eigenvectors to original PCA signs
for (j in 1:d) {
  if (sum(pca$vectors[, j] * pca_rec$vectors[, j]) < 0) {
    pca_rec$vectors[, j] <- -pca_rec$vectors[, j]
  }
}

cat("\n============================================================\n")
cat("PCA RECOVERY FROM NNS DECOMPOSITION\n")
cat("============================================================\n")

cat("\nOriginal eigenvalues:\n")
print(round(pca$values, 8))

cat("\nRecovered eigenvalues:\n")
print(round(pca_rec$values, 8))

cat("\nEigenvalue differences:\n")
print(round(pca$values - pca_rec$values, 12))

cat("\nMax absolute eigenvector difference after sign alignment:\n")
print(max(abs(pca$vectors - pca_rec$vectors)))

# -----------------------------------------------------------------------------
# 6. Between-orthant eigensystem
# -----------------------------------------------------------------------------

pca_B <- eigen(Sigma_B)

v1_B <- pca_B$vectors[, 1]
if (sum(v1_B * spread) < 0) v1_B <- -v1_B

cat("\n============================================================\n")
cat("BETWEEN-ORTHANT EIGENSTRUCTURE\n")
cat("============================================================\n")

cat("\nLeading eigenvector of Sigma_B:\n")
print(round(v1_B, 6))

cat("\nAlignment of Sigma_B PC1 with simple market factor:\n")
print(abs(sum(v1_B * market)))

cat("\nAlignment of Sigma_B PC1 with spread factor:\n")
print(abs(sum(v1_B * spread)))

cat("\nAlignment of Sigma_B PC1 with full covariance PC1:\n")
print(abs(sum(v1_B * v1)))

# -----------------------------------------------------------------------------
# 7. Eigenvalue attribution along classical PCA directions
# -----------------------------------------------------------------------------

attrib <- data.frame(
  eigen_index = 1:d,
  eigenvalue = pca$values,
  between = NA_real_,
  within = NA_real_,
  total = NA_real_,
  between_pct = NA_real_
)

for (i in 1:d) {
  v <- pca$vectors[, i]
  between_i <- drop(t(v) %*% Sigma_B %*% v)
  within_i  <- drop(t(v) %*% Sigma_W %*% v)

  attrib$between[i] <- between_i
  attrib$within[i] <- within_i
  attrib$total[i] <- between_i + within_i
  attrib$between_pct[i] <- 100 * between_i / attrib$total[i]
}

cat("\n============================================================\n")
cat("EIGENVALUE ATTRIBUTION\n")
cat("============================================================\n")

print(round(attrib, 6))

cat("\nCheck eigenvalue attribution recovery:\n")
print(max(abs(attrib$total - pca$values)))

# -----------------------------------------------------------------------------
# 8. Orthant-level attribution of PC1
# -----------------------------------------------------------------------------

pc1_contrib <- data.frame(
  orthant = integer(),
  pattern = character(),
  p = numeric(),
  contribution = numeric(),
  contribution_pct_lambda1 = numeric(),
  stringsAsFactors = FALSE
)

for (lab in sort(unique(orthant_label))) {
  mask <- orthant_label == lab
  p_r <- sum(mask) / n

  Zr <- Z[mask, , drop = FALSE]
  m_r <- colMeans(Zr)
  u_r <- m_r - mu

  contrib <- p_r * sum(v1 * u_r)^2

  pc1_contrib <- rbind(
    pc1_contrib,
    data.frame(
      orthant = lab,
      pattern = decode_orthant(lab, d, asset_names),
      p = p_r,
      contribution = contrib,
      contribution_pct_lambda1 = 100 * contrib / pca$values[1],
      stringsAsFactors = FALSE
    )
  )
}

pc1_contrib <- pc1_contrib[order(-pc1_contrib$contribution), ]

cat("\n============================================================\n")
cat("TOP ORTHANT CONTRIBUTIONS TO PC1\n")
cat("============================================================\n")

print(head(pc1_contrib, 10), digits = 6)

cat("\nSum of orthant-level between contributions for PC1:\n")
print(sum(pc1_contrib$contribution))

cat("\nDirect between contribution for PC1:\n")
print(attrib$between[1])

# -----------------------------------------------------------------------------
# 9. Interpret the top orthants
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("INTERPRETATION\n")
cat("============================================================\n")

cat("\nThis example was designed so the strongest factor is not the market.\n")
cat("The market factor has same-sign loadings on all five assets.\n")
cat("The spread factor has positive loadings on assets 1 and 2 and\n")
cat("negative loadings on assets 3, 4, and 5.\n")

cat("\nIf the experiment worked:\n")
cat("  1. PC1 aligns with the spread factor, not the market factor.\n")
cat("  2. PC2 aligns more closely with the market factor.\n")
cat("  3. The NNS decomposition recovers the same PCA eigensystem.\n")
cat("  4. The top orthants correspond to spread regimes, such as\n")
cat("     assets 1 and 2 above mean while assets 3, 4, 5 are below mean,\n")
cat("     or the reverse.\n")

cat("\nBottom line:\n")
cat("  PCA says PC1 is the dominant variance axis.\n")
cat("  NNS says which directional regimes created that axis.\n")
```
