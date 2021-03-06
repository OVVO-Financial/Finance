# Comparison of Optimization Methods on Conditioned DJIA Securities for Optimum Omega (UPM(1)/LPM(1))
## DEOptim
```{r}
## Suggested DE parameters used from http://www.hvass-labs.org/people/magnus/publications/pedersen10good-de.pdf
## and https://cran.r-project.org/web/packages/DEoptim/vignettes/DEoptimPortfolioOptimization.pdf

start <- Sys.time()

AA <- as.matrix(Conditioned)
n= ncol(AA)
optOmega <- function(x, ret = coredata(AA), L=1) {
  penalty <- (1-sum(x))^2
  x <- x/sum(x)
  objective <- -Omega( ret %*% x, L=L, method="simple" ) 
  
  return( objective + penalty)
  }

lower = rep(0,n)
upper = rep(1,n)

res = DEoptim(optOmega,lower,upper,
              control=list(NP=75,itermax=3000,CR=0.8803,F=0.4717),
              ret=coredata(AA),L=1.0)
              
om<- res$optim$bestmem/sum(res$optim$bestmem)
end <- Sys.time()

end - start
```
Iteration: 3000 bestvalit: -1.589227 bestmemit:    0.000000    0.000013    0.001387    0.010186    0.000109    0.000019    0.005487    0.000000    0.021900    0.000007    0.000204    0.000002    0.000073    0.191901    0.000000    0.000013    0.026816    0.000005    0.000000    0.001637    0.000000    0.000010    0.000000    0.308114    0.064633    0.000069    0.347334    0.015702    0.012847    0.000705

### Time difference of 4.1709 mins
### RESULT = 1.589227


## VN.opt
```{r}
start<- Sys.time()
  LPM.degree <<- 1;UPM.degree<<- 1;
  LPM.target = 1.00000;UPM.target=1.00000;
  Conditioned.port=VN.opt(Conditioned,objective.function = 1);
  end<- Sys.time()
  end-start
  
UPM/LPM 
1.603907 

     [,1] [,2]              
[1,] MMM  0.199074074074074 
[2,] V    0.122685185185185 
[3,] DIS  0.268518518518519 
[4,] UNH  0.0578703703703704
[5,] AAPL 0.314814814814815 
[6,] HD   0.037037037037037 
```
### Time difference of 28.00371 secs
### RESULT = 1.603907


