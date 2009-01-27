\name{Stem.Simulation}
\alias{Stem.Simulation}

\title{ Simulation of spatio-temporal data }
\description{
 The function \code{Stem.Simulation} simulates spatio-temporal data.
}

\usage{
Stem.Simulation(StemModel)
}

\arguments{
  \item{StemModel}{ an object of class \dQuote{Stem.Model} given as output by the \code{\link{Stem.Model}} function.  }
}
\details{
  Note that the values contained in \code{StemModel$skeleton$phi} are used as the true values of the parameters.
}

\value{
  The functions return a \eqn{n \times d}{n * d} matrix of data.
}

\references{ 
Amisigo, B.A., Van De Giesen, N.C. (2005) \emph{Using a spatio-temporal dynamic state-space model with the EM algorithm to patch gaps in daily riverflow series}. Hydrology and Earth System Sciences 9, 209--224.

Fasso', A., Cameletti, M., Nicolis, O. (2007) \emph{Air quality monitoring using heterogeneous networks}. Environmetrics 18, 245--264.

Fasso', A., Cameletti, M. (2007) \emph{A general spatio-temporal model for environmental data}. Tech.rep. n.27 \emph{Graspa} - The Italian Group of Environmental Statistics - \url{ http://www.graspa.org }.

Fasso', A., Cameletti, M. (2009) \emph{A unified statistical approach for simulation, modelling, analysis and mapping of environmental data}.
Accepted for publication by \emph{Simulation: transaction of the Society for Modeling and Simulation International}.


Mc Lachlan, G.J., Krishnan, T. (1997) \emph{The EM Algorithm and Extensions}. Wiley, New York.

Shumway, R.H., Stoffer, D.S. (2006) \emph{Time Series Analysis and Its Applications: with R Examples}. Springer, New York.

Xu, K., Wikle, C.K. (2007) \emph{Estimation of parameterized spatio-temporal dynamic models}. Journal of Statistical Inference and Planning 137,  567--588.

 }

\author{ Michela Cameletti \email{ michela.cameletti@unibg.it } }

\seealso{ \code{\link{pm10}} and \code{\link{Stem.Model}}}

\examples{
data(pm10)
names(pm10)

#extract the data
coordinates <- pm10$coords
covariates <- pm10$covariates
z <- pm10$z

#build the parameter list
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

simulateddata = Stem.Simulation(mod1)
}

\keyword{ models }
\keyword{ spatial }
