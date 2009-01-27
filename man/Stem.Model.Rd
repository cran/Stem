\name{Stem.Model}
\alias{Stem.Model}
\alias{is.Stem.Model}

\title{ Create a Stem Model }
\description{
  The function \code{Stem.Model} is used to create an object of class \dQuote{Stem.Model}.

}
\usage{
Stem.Model(...)

is.Stem.Model(x)
}

\arguments{
  \item{\dots}{ List with named elements: \code{phi}, \code{K}, \code{z}, \code{coordinates}, \code{covariates} and, optionally, \code{p} (default equal to 1). See the model details and notation
  below.}
\item{x}{ an object of class Stem.Model}
}

\details{
The hierarchical spatio-temporal model is given by
    \deqn{z_t = X_t \beta  + K y_t + e_t , e_t \sim N(0, \Sigma_e )}{z_t = X_t * \beta  + K * y_t + e_t , e_t ~ N(0, \Sigma_e )}
    \deqn{y_t = G y_{t-1} + \eta_t , \eta_t \sim N(0,\Sigma_{\eta})}{y_t = G * y_{t-1} + \eta_t , \eta_t ~ N(0,\Sigma_{\eta})}
    for \eqn{t=1,...,n}.
The initialization is given by \eqn{ y_0 \sim N(m0,C0).}{ y_0 ~ N(m0,C0).} \cr
Note that \eqn{z_t}{z_t} has dimension \eqn{d} by 1, where \eqn{d} is the number of spatial locations and \eqn{y_t}{y_t} has dimension \eqn{p} by 1, where \eqn{p}
is the dimension of the latent process. The matrix \eqn{X_t}{X_t} is the known covariate matrix and has dimension \eqn{d} by \eqn{r}, where \eqn{r} is the number of covariates.
Moreover, the \eqn{d}{d}-dimensional square matrix \eqn{\Sigma_e}{\Sigma_e} is given by \eqn{\sigma^2_\epsilon+\sigma^2_\omega}{\sigma^2_\epsilon+\sigma^2_\omega} in the diagonal (for spatial distance \eqn{h} equal to 0), while the off-diagonal entries are given by 
\eqn{\sigma^2_\omega C(h,\theta)}{\sigma^2_\omega * C(h,\theta)}, where \eqn{C(h,\theta)} is the spatial covariance function. Using the default 
\emph{exponential} spatial covariance function, it is \eqn{C(h,\theta)=\exp(-\theta h)}{C(h,theta)=\exp(-\theta* h)}. \cr
So the parameter vector \eqn{\phi} is composed by \eqn{\beta}, \eqn{\sigma^2_\epsilon}, \eqn{\sigma^2_\omega}, \eqn{\theta}, \eqn{G},
\eqn{\Sigma_\eta} and \eqn{m0} (\eqn{C0} is supposed fixed).


The elements required by the function \bold{must} have the following characteristics:
\describe{
\item{phi}{is a list composed by: \code{beta} (matrix \eqn{r \times 1}{r * 1}), \code{sigma2eps} (scalar), \code{sigma2omega} (scalar),
\code{theta} (scalar), \code{G} (matrix \eqn{p \times p}{p * p}), \code{Sigmaeta} (matrix \eqn{p \times p}{p * p}), \code{m0} (matrix \eqn{p \times 1}{p * 1}), \code{C0} (matrix \eqn{p \times p}{p*p}). Note that these values will be used as the true parameter values in the \code{\link{Stem.Simulation}} function and as initial values for the EM algorithm in the \code{\link{Stem.Estimation}} function}.
\item{K}{loading matrix \eqn{d} by \eqn{p}.}
\item{z}{observation matrix \eqn{n} by \eqn{d}.}
\item{coordinates}{matrix \eqn{d} by 2 with UTMX-UTMY or LAT-LON coordinates.}
\item{covariates}{matrix \eqn{(n \times d)\times r}{(n * d)* r}. It is recommended to build the covariate matrix stacking the data by station.
This means that you consider the \eqn{n} by \eqn{r} matrices related to each spatial location and stack them until you get a \eqn{(n \times d)\times r}{(n * d)* r} matrix.}
     }
%Note that the dimension p of the state process \eqn{y_t} is not required and is by default fixed equal to 1.
}


\value{
The function returns a list which is given by:
  \item{skeleton}{a list with components \code{phi}, \code{p}, \code{K} as given in the input.}
  \item{data}{a list with components \code{z}, \code{coordinates}, \code{covariates}, as given in the input, \code{r}, \code{n} and \code{d}.}

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

\section{Warning }{No missing values are admitted in the observation matrix \code{z}, in the covariates matrix \code{covariates} and in the \code{coordinates} matrix. }

\seealso{ \code{\link{pm10}}}

\examples{
#load the data
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
}

\keyword{ models }
\keyword{ spatial }