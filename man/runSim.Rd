% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runSim.R
\name{runSim}
\alias{runSim}
\title{Run simulation on population.}
\usage{
runSim(
  pop,
  pedigree = NULL,
  generations = 2,
  selection = "random",
  fitness = "phenotypic",
  burnIn = 0,
  truncSire = 1,
  truncDam = 1,
  roundsSire = 1,
  roundsDam = 1,
  litterDist = c(0, 0, 1),
  breedSire = 10,
  mutation = 10^-9,
  recombination = NULL,
  allGenoFileName = NULL
)
}
\arguments{
\item{pop}{a valid \code{Population} object with all necessary
additive and epistatic effects attached}

\item{pedigree}{an optional \code{data.frame} giving the pedigree
to follow for selection}

\item{generations}{an optional integer giving the number of
generations to iterate through in the simulation}

\item{selection}{an optional string specifying random (the default) or
linear ranking selection}

\item{fitness}{an optional string specifying whether selection takes
place based on phenotypic value (the default), true genetic value or
estimated breeding value}

\item{burnIn}{an optional integer giving the initial number of
generations in which to use random selection without truncation,
even when linear ranking selection or truncation is otherwise employed}

\item{truncSire}{an optional value giving the proportion of the
males in the population with the highest phenotypic value to
select within}

\item{truncDam}{an optional value giving the proportion of the
females in the population with the highest phenotypic value to
select within}

\item{roundsSire}{an optional integer giving the maximum number of
generations for a male to survive; see details below}

\item{roundsDam}{an optional integer giving the maximum number of
generations for a female to survive; see details below}

\item{litterDist}{an optional vector giving the probability mass
function for the litter sizes, starting with a litter of 0}

\item{breedSire}{an optional integer indicating the maximum number
of times that a sire can breed per generation}

\item{mutation}{an optional value giving the rate of mutation per
SNP}

\item{recombination}{an optional vector giving the probabilities
for recombination events between each SNP}

\item{allGenoFileName}{a string giving a file name,
indicating that all genotypes will be outputted to the file during the run}
}
\value{
A new \code{Population} object is returned.
}
\description{
Run a forward-time simulation on a \code{Population} object.
}
\details{
\code{runSim} is the forward-time simulation engine of the
\code{epinetr} package. A \code{Population} object with necessary
additive and epistatic effects must be supplied; all other
arguments are optional, though either \code{pedigree} or
\code{generations} must be supplied.

\code{pedigree} should be a \code{data.frame} where the first
three columns are the ID, sire ID and dam ID respectively. Sire
and dam IDs of 0 indicate that the individual is in the first
generation; each ID in the first generation should match an ID in
the given \code{Population} object. The pedigree will be sorted
into generations before running, where a 'generation' in this case
is defined as the set of individuals whose parents are both from a
previous generation. If a pedigree is supplied, all further
arguments (which pertain to selection) will be ignored.

\code{generations} is the number of generations through which the
simulation will iterate. The supplied population represents the
first generation: the default value of 2 for this argument thus
means that the simulator will simply return the next generation.

\code{selection} is a string specifying 'ranking' for linear
ranking selection; any other string is interpreted as 'random' for
random selection.

Linear ranking selection mimics natural selection: if the
individuals in a population of size \eqn{n} are each given a rank
\eqn{r} based on descending order of phenotypic value (i.e. the
individual with the highest phenotypic value is given the rank
\ifelse{html}{\out{<i>r</i><sub>1</sub> = 1}}{{\eqn{r_1 = 1}}{r_1 = 1}} while the individual with the lowest phenotypic value
is given the rank \ifelse{html}{\out{<i>r<sub>n</sub></i> = <i>n</i>}}{{\eqn{r_n = n}}{r_n = n}}), the probability of an individual
\eqn{i} being selected for mating is given by:

\ifelse{html}{
\out{
<i>P</i>(<i>i</i> is selected) = 2(<i>n</i> - <i>r<sub>i</sub></i> + 1) / <i>n</i>(<i>n</i> + 1)
}}{{
\deqn{P(i \textrm{ is selected}) = \frac{2(n - r_i + 1)}{n(n + 1)}}
}{
P(i is selected) = 2(n - r_i + 1) / n(n + 1)
}}

Selection occurs by the population first being split into male and female
sub-populations. Next, if the round is outside any initial burn-in period,
each sub-population is truncated to a proportion of its original size per
the values of \code{truncSire} and \code{truncDam}, respectively.

When linear ranking selection is used, females are exhaustively
sampled, without replacement, for each mating pair using their linear
ranking probabilities, as given above; males are sampled for each mating
pair using their linear ranking probabilities but with replacement, where
they are each only replaced a maximum number of times as specified by
\code{breedSire}. Random selection occurs in the same manner, but all
probabilities are uniform. During any initial \code{burnIn} period, random
selection is enforced.

\code{fitness} specifies how fitness is determined for the purposes of selection:
'phenotypic' (the default) selects based on the phenotype while 'TGV' selects by
ignoring environmental noise; 'EBV' selects based on estimated breeding values
using estimated SNP effects.

Each mating pair produces a number of full-sibling offspring by sampling
once from the litter-size probability mass function given by \code{litterDist}
(with the default guaranteeing two full-sibling offspring per mating pair).
The PMF is specified via a vector giving the probabilities for each
litter size, starting with a litter size of 0. For example,
\code{c(0.2, 0.0, 0.1, 0.4, 0.3)} gives a 20\% chance of a litter
size of 0, a 10\% chance of litter size of 2, a 40\% chance of a
litter size of 3, a 30\% chance of a litter size of 4 and a 0\%
chance of a litter size of 1 or greater than 4.

Half-siblings occur when sires can mate more than once per round (as given by
\code{breedSire}) or when sires or dams survive beyond one round (as given by
\code{roundsSire} and \code{roundsDam}, respectively). It is important to note
that \code{roundsSire} and \code{roundsDam}, which specify the maximum number
of generations for males and females to survive, respectively, will be ignored
in the case where an insufficient number of offspring are produced to replace
the individuals who have nonetheless survived the maximum number of rounds: in
this case, younger individuals will be preserved in order to meet the
population size.

\code{recombination} is a vector of recombination rates between
SNPs. The length of this vector should be equal to the number of
SNPs in the population's \code{map} minus the number of
chromosomes. The order of the chromosomes is as per the
\code{map}.

\code{allGenoFileName} is the name of a file in which the
phased genotype for every individual will be stored. The output
is serialised and can be read using \code{loadGeno}. If the
\code{allGenoFileName} argument is not given, no genotypes
will be written to file.
}
\examples{
\donttest{
# Create population
pop <- Population(
  popSize = 200, map = map100snp, QTL = 20,
  alleleFrequencies = runif(100),
  broadH2 = 0.9, narrowh2 = 0.6, traitVar = 40
)

# Attach additive effects using a normal distribution
pop <- addEffects(pop)

# Attach epistatic effects
pop <- attachEpiNet(pop)

# Run simulation for 150 generations
pop <- runSim(pop, generations = 150)

# Display results
pop

# Plot results
plot(pop)
}
}
\seealso{
\code{\link{Population}}, \code{\link{addEffects}},
\code{\link{attachEpiNet}}, \code{\link{print.Population}},
\code{\link{plot.Population}}, \code{\link{loadGeno}}
}
\author{
Dion Detterer, Paul Kwan, Cedric Gondro
}
