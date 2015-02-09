# FedData Tester
devtools::install_github("bocinsky/FedData")
library(FedData)

setwd("/Users/Bocinsky/Desktop/FedDataTest")

# Get a random contiguous USA county for testing
county <- rgdal::readOGR("/Volumes/DATA/NATIONAL_ATLAS/countyp010","countyp010g")
county <- county[county$STATE=="GA" & county$NAME=="Cherokee",]
# county <- county[!(county$STATE %in% c("AK","HI","PR","VI")),]
# county <- county[sample(1:length(county),1),]

# Get the NED (USA ONLY)
# Returns a raster
NED <- getNED(template=county, label=paste(county$STATE,'_',county$NAME, sep=''), res='1')

# Get the daily GHCN data (GLOBAL)
# Returns a list: the first element is the spatial locations of stations,
# and the second is a list of the stations and their daily data
GHCN.prcp <- getGHCNDaily(template=county, label=paste(county$STATE,'_',county$NAME, sep=''), elements=c('prcp'), standardize=F)
GHCN.temp <- getGHCNDaily(template=county, label=paste(county$STATE,'_',county$NAME, sep=''), elements=c('tmin','tmax'), standardize=T)

# Get the NHD (USA ONLY)
NHD <- getNHD(template=county, label=paste(county$STATE,'_',county$NAME, sep=''))

# Get the NRCS SSURGO2 data
NRCS <- getNRCS(template=county, label=paste(county$STATE,'_',county$NAME, sep=''))










plot(NED)
plot(county, add=T)
plot(GHCN.prcp[[1]], pch=17, add=T)
plot(GHCN.temp[[1]], pch=19, add=T)
plot(NHD$NHDFlowline, col='gray50', border='gray50', add=T)
plot(NHD$NHDWaterbody, col='gray50', border='gray50', add=T)
plot(NHD$NHDArea, col='gray50', border='gray50', add=T)

plot(NRCS[['spatial']])





library(ncdf)
ex.nc <- open.ncdf("/Volumes/DATA/DAYMET/prcp_2000.nc4")
ex.nc.rast <- brick(ex.nc)
test <- ex.nc[[1:2]]

writeRaster(test, "/Users/Bocinsky/Desktop/test.nc", overwrite=T)
test2 <- brick("/Users/Bocinsky/Desktop/test.nc")