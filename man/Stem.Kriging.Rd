\name{Stem.Kriging}
\alias{Stem.Kriging}

\title{ Dynamical spatial mapping }
\description{
This functions performs spatial prediction in a set of new \eqn{S} spatial locations for a fixed time point.
}
\usage{
Stem.Kriging(StemModel, coord.newlocations, covariates.newlocations,
K.newlocations, time.point, cov.spat = Sigmastar.exp)
}

\arguments{
  \item{StemModel}{ an object of class \dQuote{Stem.Model} given as output by the \code{\link{Stem.Estimation}} function. }
  \item{coord.newlocations}{ a matrix or a data frame of dimension \eqn{S} by 2. }
  \item{covariates.newlocations}{ a matrix of dimension \eqn{S} by \eqn{r}, where \eqn{r} is the number of covariates as in the \code{StemModel} object. \cr
 It has the same structure of the  \code{StemModel$data$covariates} object in the sense that each station data set is stacked under the others; see the \code{DETAILS} of the \code{\link{Stem.Model}} function. }
  \item{K.newlocations}{ a loading matrix of dimension \eqn{S} by p. }
  \item{time.point}{ the time point between 1 and \eqn{n} for which the spatial prediction is performed. }
  \item{cov.spat}{ type of spatial covariance function. For the moment only the \emph{exponential} function is implemented. }
}
\details{
  Given the observation matrix and using the multivariate Normal distribution standard theory, the predictor in the new generic spatial location
  \eqn{s_0} at time \eqn{t} is an univariate Gaussian distribution with mean \eqn{z(s_0,t)} and variance \eqn{\sigma^2(s_0)} given by:

  \deqn{z(s_0,t) = X(s_0,t)\beta+K(s_0)y_t+\Omega^{\prime} \Sigma_e^{-1} (z_t-X_t\beta+K y_t)}{z(s_0,t) = X(s_0,t)*\beta+K(s_0)*y_t+\Omega '*\Sigma_e^{-1}*(z_t-X_t*\beta+K*y_t)}
  \deqn{\sigma^2(s_0)=\sigma^2{\omega}-\Omega^{\prime}\Sigma_e^{-1} \Omega }{\sigma^2(s_0)=\sigma^2{\omega}-\Omega '*\Sigma_e^{-1}*\Omega }

where \eqn{\Omega} is the \eqn{d \times 1}{d*1} constant in time covariance vector, whose \eqn{i}-th generic element (\eqn{i=1,...,d}) is
\eqn{Cov(z(s_i,t),z(s_0,t))}. Moreover,  \eqn{X(s_0,t)}{X(s_0,t)} is the \eqn{1 \times r}{1*r} vector of covariates for the new site \eqn{s_0}{s_0} and \eqn{K(s_0)}{K(s_0)} is the \eqn{1 \times p}{1*p} loading vector. Note that all the parameters in the previous formula are ML estimates and the latent process \eqn{y_t} is the output of the
Kalman filtering procedures for each time point \eqn{t}.
}

\value{
The function returns a list which is given by:
  \item{data.newlocations }{a list of five objects related to the new spatial locations: the coordinates (\code{coordinates}),
 the covariates (\code{covariates}), the \code{K} matrix, the predictions \code{z} and the prediction standard errors (\code{se.pred}).}
  \item{time.point }{the time point for which the spatial prediction is performed.}

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

\author{
Michela Cameletti \email{ michela.cameletti@unibg.it }
}

\seealso{ See Also \code{\link{pm10}}, \code{\link{Stem.Model}} and \code{\link{Stem.Estimation}} }

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

K<-matrix(1,ncol(z),1)

mod1 <- Stem.Model(z=z,covariates=covariates,coordinates=coordinates,phi=phi,K=K)
class(mod1)
is.Stem.Model(mod1)

#mod1 is given as output by the Stem.Model function
mod1.est <- Stem.Estimation(mod1)

#coordinates of the 25 new points displaced in a regular grid (S=25)
xxx  <- seq(400,470,length=5)
yyy <- seq(5000,5070,length=5)
coord.new <- expand.grid(x=xxx,y=yyy)

#plot of the spatial locations
plot(pm10$coords[,1],pm10$coords[,2],xlab=colnames(pm10$coords)[1],
ylab=colnames(pm10$coords)[2])
points(coord.new[,1],coord.new[,2],col=2,pch=19)
legend("topleft",col=c(1,2),lty=c(0,0), pch=c(21,19),
legend=c("Original spatial locations","New spatial locations"))

#the covariates matrix for the new 25 spatial locations for the 10th time point
covariates.new <- cbind(rep(1,25),  
c(37.98348, 18.14824, 15.32287, 11.00458, 6.67696,
29.120820, 10.487590, 2.401088, 26.112971, 1.683525,
19.211907, 31.363448, 3.629172, 10.352472, 48.289624,
7.199692, 3.524810, 25.546621, 19.598600, 10.521586,
0.004736363, 0.365510044, 0.975484255, 25.523642458, 4.671496566),
c(0.227688, 0.173037, 0.139985, 0.116392, 0.102476,
0.278325, 0.256422, 0.168136, 0.129460, 0.121040,
0.722656, 0.238780, 0.202586, 0.166547, 0.154638,
0.733208, 1.467990, 0.380001, 0.251896, 0.240350,
 2.292299 ,2.275844 ,1.382322, 0.300729, 0.208798))

K.new<-matrix(1,25,1)

#dynamical spatial prediction (10th day)
mod1.pred <-Stem.Kriging(StemModel=mod1.est,coord.newlocations=coord.new,
			covariates.newlocations=covariates.new,
K.newlocations<-K.new,time.point=10)

#post-processing: build an image map
image(x=xxx,y=yyy,z=matrix(mod1.pred$data.newlocations$z,
length(xxx),length(yyy)),
xlab=colnames(pm10$coords)[1],ylab=colnames(pm10$coords)[2],
xlim=range(mod1.est$data$coordinates[,1])+5,
ylim=range(mod1.est$data$coordinates[,2]+5))
points(pm10$coords[,1],pm10$coords[,2])
points(coord.new[,1],coord.new[,2],col=2,pch=19)

byline <- min((range(xxx)[2]-range(xxx)[1])/4,(range(yyy)[2]-range(yyy)[1])/4)
abline(v=seq(range(xxx)[1],range(xxx)[2],by=byline),col="grey",lty=2)
abline(h=seq(range(yyy)[1],range(yyy)[2],by=byline),col="grey",lty=2)
}

\keyword{ models }
\keyword{ spatial }
