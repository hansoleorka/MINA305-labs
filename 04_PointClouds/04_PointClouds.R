## ----eval=T-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Load packages 
library("lidR")
library("sf")
library("terra")
library("ggplot2")
library("future")


## ----setup, warning=FALSE---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Read ALS file 
lasFile <- "data/frydenhaug/als2008.laz" # Filename
las <- readLAS(lasFile)
plot(las)

filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
las <- readLAS(lasFile,filter=filter)
plot(las)
head(las)
names(las)
hist(las$Z)
plot(las,color="Classification")
table(las$Classification)
plot(las,color="PointSourceID")
table(las$PointSourceID)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasFile <- "data/frydenhaug/als2021.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
las <- readLAS(lasFile,filter=filter)
plot(las)
head(las)

hist(las$Z)
plot(las,color="Intensity",pal=gray.colors(20))
plot(las,color="Classification")
table(las$Classification)
plot(las,color="PointSourceID")
plot(las,color="ScanAngleRank")
table(las$PointSourceID)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasFile <- "data/frydenhaug/dap2021.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
las <- readLAS(lasFile,filter=filter)
las
plot(las)
plot(las,color="RGB")
lasNIR <- las
lasNIR$B <- las$G
lasNIR$G <- las$R
lasNIR$R <- las$Intensity
plot(lasNIR,color="RGB")
table(lasNIR$Classification)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasFile <- "data/frydenhaug/als2021.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
las <- readLAS(lasFile,filter=filter)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Select ground echoes
ground <- readLAS(lasFile,filter=paste0(filter, " -keep_class 2"))
plot(ground)
x <- plot(ground,color="Intensity",colorPalette=gray.colors(20))
veg <- readLAS(lasFile,filter=paste0(filter, " -drop_class 2"))
plot(veg,add=x)

# DTM
dtm <- rasterize_terrain(las, res = 1, algorithm = tin())
x <- plot(veg)
add_dtm3d(x, dtm)
plot(dtm)

# DSM
dsm <- rasterize_canopy(las,res = 1, algorithm = dsmtin())
plot(dsm)

chm <- dsm - dtm
plot(chm)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasdz <- normalize_height(las, tin())
plot(lasdz)
table(lasdz$Classification)
plot(lasdz,color="Classification")


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
chm2021 <- chm
lasFile <- "data/frydenhaug/als2008.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
las <- readLAS(lasFile,filter=filter)
dtm <- rasterize_terrain(las, res = 1, algorithm = tin())
dsm <- rasterize_canopy(las,res = 1, algorithm = dsmtin())
chm2008 <- dsm - dtm
diff <- chm2021 - chm2008
plot(diff)


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
chm2021 <- chm
lasFile <- "data/frydenhaug/dap2021.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030" #Filter to only select a spesific area  
dap <- readLAS(lasFile,filter=filter)
dsmdap <- rasterize_canopy(dap,res = 1, algorithm = dsmtin())
chmdap <- dsmdap - dtm
diff <- chm2021 - chmdap
plot(diff)



## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(lidR)
lasFile <- "data/vaaler/0008.las"
filter <- "-keep_xy 606200 6600150 606500 6600450" 
las <- readLAS(lasFile,filter=filter)
plot(las)
head(las)
plot(las,color="Classification")
plot(las,color="PointSourceID")
table(las$Classification)
table(las$ReturnNumber)
plot(las,color="Intensity",pal=gray.colors(20))


## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasdz <- normalize_height(las, tin())
plot(lasdz)
table(lasdz$Classification)
plot(lasdz,color="Classification")
lasdz_no_noise <- classify_noise(lasdz,algorithm=ivf(5,2))
table(lasdz_no_noise$Classification)
lasdz_filtered <- filter_poi(lasdz_no_noise,Classification != 7 & Classification != 18)
plot(lasdz_filtered,color="Classification")
plot(lasdz_filtered)


## ----eval=FALSE-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ctg <- readLAScatalog("data/vaaler/")
# opt_filter(ctg) <- "-keep_classification 0 1 2"
# opt_output_files(ctg) <-  paste0("data/vaalerdz/", "/{ORIGINALFILENAME}_norm")
# ctgdz <- normalize_height(ctg, tin())


## ----echo=FALSE,include=FALSE-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("H25_04_PointClouds.Rmd")

