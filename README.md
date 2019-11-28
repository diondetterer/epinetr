# epinetr
An R Package for Epistasis and Epistastic Network Modelling with Forward-Time Simulation

## Installation
Installation is straightforward, provided you already have the `devtools` package installed. Simply run the command

```r
install_github("diondetterer/epinetr")
```

and the *epinetr* package will be installed into your R library.

## Usage
There are a vignette and a demo in the package, and we encourage users to read the vignette at least, as it provides a fairly comprehensive tutorial. However, here are some minimal commands to get you started:

```r
pop <- Population(
  popSize = 500, map = map100snp, QTL = 20,
  alleleFrequencies = runif(100), broadH2 = 0.9,
  narrowh2 = 0.75, traitVar = 40
)
```

This will create a `Population` object called `pop` with 500 individuals, a chromosome map given by `map100snp`, 20 randomly selected QTLs, randomly-generated allele frequencies, broad-sense heritability at 0.9, narrow-sense heritability at 0.75 and trait variance at 40.

```r
pop <- addEffects(pop)
pop <- attachEpiNet(pop)
```

These commands will attach additive and epistatic effects to the population.

```r
plot(getEpiNet(pop))
```

This will provide a visualisation of the epistatic network.

```r
pop <- runSim(pop, generations = 150)
```

This will run the simulator for 150 generations.

Finally, plot the run:

```r
plot(pop)
```
