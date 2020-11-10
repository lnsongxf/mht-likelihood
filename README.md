# The Likelihood of Mixed Hitting Times

This repository contains MATLAB code for replicating the numerical results in [Abbring and Salimans (2021)](https://arxiv.org/abs/1905.03463). This covers the computation of the likelihood of the [mixed hitting-time model](http://jaap.abbring.org/images/pdf/ecta7312.pdf), maximum likelihood estimation of parametric versions of this model, and an application to the analysis of [Kennan's (1985) strike data](https://www.ssc.wisc.edu/~jkennan/research/JEM85.pdf).

## Contents
Use `make` to replicate [Abbring and Salimans (2021)](https://arxiv.org/abs/1905.03463). This runs the following MATLAB scripts:

- `figure1.m` -  replicates Figure 1
- `figure2.m` -  replicates Figure 2
- `figure3.m` -  replicates Figure 3
- `simulateEstimate.m` - simulates data and estimates the model on these data
- `table1.m` - replicates Table 1
- `table1lowM` - recalculates Table 1 with a lower value of the design parameter `M`
- `table1BM.m` - recalculates Columns I-V of table one using the exact likelihood for the Gaussian case

Users can adapt these scripts to apply the procedures they call in other contexts. The scripts require a range of functions and a data set.

### Specification, likelihood calculation, and maximum likelihood estimation

The procedures require parametric specifications `<heter>` of the unobserved heterogeneity specification and `<shocks>` of the jumps in the latent Lévy process. The calculation of the Laplace transform of .. for each such specification is coded up as a function `<heter><shocks>` in a file `<heter><shocks>.m`:

- `pointpoint.m` - Discrete heterogeneity and discrete shocks at Poisson times
- `pointgamma.m` - Discrete heterogeneity and gamma shocks at Poisson times
- `gammapoint.m` - Gamma heterogeneity and discrete shocks at Poisson times
- `gammagamma.m` - Gamma heterogeneity and gamma shocks at Poisson times

Users can extend the set of specifications by adding different functions `<heter><shocks>`.

### Likelihood calculation

- `minusLoglikelihood.m` - function that returns minus the log likelihood (calculated by Laplace transform inversion)
- `minusLoglikBM.m` - function that returns minus the log likelihood (calculated using explicit expressions for the Gaussian case)

### Maximum likelihood estimation

- `mhtMaxLikelihood.m` - general case (based on Laplace inversion)
- `mhtMaxLikBM.m` - Gaussian special case

### Auxiliary functions

- `igausscdf.m`n - inverse Gaussian cdf
- `igausspdf.m` - inverse Gaussian pdf
- `randraw.m` -  random draws from ...

### Data

- `strdur.asc` - Fixed format text file with [Kennan's (1985) strike data](https://www.ssc.wisc.edu/~jkennan/research/JEM85.pdf) (source: [Cameron and Trivedi’s, 2005, data sets page](http://cameron.econ.ucdavis.edu/mmabook/mmadata.html)).

## References
- Abbring, Jaap H., and Tim Salimans (2021), “[The likelihood of mixed hitting times](https://arxiv.org/abs/1905.03463)”, *Journal of Econometrics*, forthcoming. arXiv:1905.03463 \[econ.EM\].
- Cameron, A. Colin, and Pravin K. Trivedi (2005), *[Microeconometrics: Methods and Applications](http://cameron.econ.ucdavis.edu/mmabook/mma.html)*, Cambridge: Cambridge University Press.
- Kennan, John (1985), "[The duration of contract strikes in U.S. manufacturing](https://www.ssc.wisc.edu/~jkennan/research/JEM85.pdf)", *Journal of Econometrics*, 28, 5–28.
