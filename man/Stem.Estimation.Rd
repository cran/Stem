\name{Stem.Estimation}
\alias{Stem.Estimation}

\title{ ML Estimation }
\description{
The function computes the maximum likelihood estimates of the unknown parameters of a hierarchical spatio-temporal model of class \dQuote{Stem.Model}. The estimates are obtained
using Kalman filtering and EM algorithm.
}
\usage{
Stem.Estimation(StemModel, precision = 0.01, max.iter = 50, 
flag.Gdiag = TRUE, flag.Sigmaetadiag = TRUE, cov.spat = Sigmastar.exp)
}

\arguments{
  \item{StemModel}{ an object of class \dQuote{Stem.Model} given as output by the \code{\link{Stem.Model}} function. }
  \item{precision}{ a small positive number used for the algorithm convergence. Default is equal to 0.01. See \code{DETAILS} below. }
  \item{max.iter}{ maximum number of iterations for the EM algorithm. Default is equal to 50.}
  \item{flag.Gdiag}{ logical, indicating whether the transition matrix \eqn{G} is diagonal. }
  \item{flag.Sigmaetadiag}{ logical, indicating whether the variance-covariance matrix of the state equation \eqn{\Sigma_\eta} is diagonal. }
  \item{cov.spat}{ type of spatial covariance function. For the moment only the \emph{exponential} function is implemented. }
}

\details{
  This function estimates the vector parameter \code{phi} of the hierarchical spatio-temporal model of class \dQuote{Stem.Model} using Kalman filtering and EM algorithm.
  The algorithm details and formulas are given in Fasso' and Cameletti (2007, 2009). Note that some parameters (\code{beta}, \code{sigma2omega},
  \code{G}, \code{Sigmaeta} and \code{m0}) are updated using closed form solutions while \code{theta} and \code{sigma2epsilon} using the Newton-Raphson algorithm.

  For initializing the algorithm the values contained in \code{StemModel$skeleton$phi} are used as initial values.
  The algorithm converges when the following convergence criteria (named in the output as \code{conv.par} and \code{conv.log} respectively) are jointly met

  \deqn{\frac{\left\|\phi^{\left(i+1\right)}-\phi^{\left(i\right)}
  \right\|}{\left\|\phi^{\left(i\right)}\right\|} < \pi }{||\phi^{i+1}-\phi^{i}
  || / ||\phi^{i}|| < \pi }

  \deqn{\frac{\left\|\log L\left( \phi^{\left(i+1\right)}\right)-\log
  L\left( \phi^{\left(i\right)}\right)\right\|}{\left\|\log
  L\left( \phi^{\left(i\right)}\right)\right\|}<\pi}{||log L(\phi^{i+1}-log
  L(\phi^{i})|| / ||log L(\phi^{i})||<\pi}

where \eqn{\pi} is given by the \code{precision} option and \eqn{i} is the number of iteration. The use of these relative criteria instead of some other absolute ones makes it possible to
correct for the different parameter scales.
}

\value{

The function returns an object of class \dQuote{Stem.Model} which is a list given by:

  \item{skeleton}{As the \code{skeleton} component of the \code{StemModel} object given in input.}
  \item{data}{As the \code{data} component of the \code{StemModel} object given in input.}
  \item{estimates}{A list of four objects: \code{phi.hat}, \code{y.smoothed}, \code{loglik}, \code{convergence.par} here described.

 \code{phi.hat} is a list
  with the parameter ML estimates (\code{sigma2omega}, \code{beta}, \code{G}, \code{Sigmaeta}, \code{m0}, \code{C0}, \code{theta}, \code{sigma2eps}).
  \code{y.smoothed} is a \code{ts} object (\eqn{n} by \eqn{p}) which is the output of the Kalman filtering procedure. \code{loglik} is the log-likehood value.
  \code{convergence.par} is a list of 4 objects with some information about the convergence of the algorithm: \code{conv.log} and \code{conv.par} are logical values
  for the two convergence criteria described above; \code{iterEM} is the number of iterations for the EM algorithm and \code{iterNR} is the number of
  Newton-Raphson iterations for each EM algorithm iteration.}
}

\references{

Amisigo, B.A., Van De Giesen, N.C. (2005) \emph{Using a spatio-temporal dynamic state-space model with the EM algorithm to patch gaps in daily riverflow series}. Hydrology and Earth System Sciences 9, 209--224.

Fasso, A., Cameletti, M., Nicolis, O. (2007) \emph{Air quality monitoring using heterogeneous networks}. Environmetrics 18, 245--264.

Fasso', A., Cameletti, M. (2007) \emph{A general spatio-temporal model for environmental data}. Tech.rep. n.27 \emph{Graspa} - The Italian Group of Environmental Statistics - \url{ http://www.graspa.org }.

Fasso', A., Cameletti, M. (2009) \emph{A unified statistical approach for simulation, modelling, analysis and mapping of environmental data}.
Accepted for publication by \emph{Simulation: transaction of the Society for Modeling and Simulation International}.

Mc Lachlan, G.J., Krishnan, T. (1997) \emph{The EM Algorithm and Extensions}. Wiley, New York.

Shumway, R.H., Stoffer, D.S. (2006) \emph{Time Series Analysis and Its Applications: with R Examples}. Springer, New York.

Xu, K., Wikle, C.K. (2007) \emph{Estimation of parameterized spatio-temporal dynamic models}. Journal of Statistical Inference and Planning 137,  567--588.

}

\author{
Michela Cameletti \email{ michela.cameletti@unibg.it }
}


\seealso{ See Also \code{\link{Stem.Model}} and \code{\link{pm10}} }


\examples{
#load the data
data(pm10)

#extract the data
coordinates <- pm10$coords
covariates <- pm10$covariates
z <- pm10$z

#build the parameter list 
#(the phi list is used for the algorithm starting values)
phi <- list(beta=matrix(c(3.65,0.046,-0.904),3,1),
			sigma2eps=0.1,
			sigma2omega=0.2,
			theta=0.01,
			G=matrix(0.77,1,1),
			Sigmaeta=matrix(0.3,1,1),
			m0=as.matrix(0),
			C0=as.matrix(1))

K <-matrix(1,ncol(z),1)

mod1 <- Stem.Model(z=z,covariates=covariates,
coordinates=coordinates,phi=phi,K=K)
class(mod1)
is.Stem.Model(mod1)

#mod1 is given as output by the Stem.Model function
mod1.est <- Stem.Estimation(mod1)
phi.estimates <- unlist(mod1.est$estimates$phi.hat)
 
}


\keyword{ models }
\keyword{ spatial }
