\name{pm10}
\alias{pm10}

\docType{data}

\title{Realistic data which illustrate the usage of the package
  Stem }

\description{
  This simple data set is a list of three objects and refers to 22 spatial locations and 366 time points.
}

\usage{
data(pm10)
}

\format{
 A list of with three objects with the following components:
  \describe{
    \item{\code{coords}}{the coordinates of the 22 spatial locations. }
    \item{\code{covariates}}{ it is a 8052 by 3 matrix referring to the following covariates: \emph{intercept, emissions (g/s) and altitude (km)}. The first 366 rows refer to the first spatial
location, the rows from 367 to 732 refer to the second spatial location and so on.   }
    \item{\code{z}}{it is a 366 by 22 observation matrix referring to \emph{PM10 concentration measurements} (log scale).  }
    }
}

\references{ 
Fasso', A., Cameletti, M. (2007) \emph{A general spatio-temporal model for environmental data}. Tech.rep. n.27 \emph{Graspa} - The Italian Group of Environmental Statistics - \url{ http://www.graspa.org }.
}

\author{ Michela Cameletti \email{ michela.cameletti@unibg.it }
}

\examples{
data(pm10)
names(pm10)

#plot the coordinates
dim(pm10$coords)
plot(pm10$coords[,1],pm10$coords[,2],xlab=colnames(pm10$coords)[1],
	ylab=colnames(pm10$coords)[2])

#plot the data
dim(pm10$z)

#summary by station
apply(pm10$z,2,summary)

#plot the time series for station n.22
plot(pm10$z[,22],t="l",xlab="Days",ylab="PM10 concentrations (log)")

#plot the station altitude
plot(pm10$covariates[,3],ylab=colnames(pm10$covariates)[3],xaxt="n",xlab="")
positions = seq(1,8052,366)+366/2
axis(1, at=positions, labels=rownames(pm10$coords), las=2)
}

\keyword{ datasets }

