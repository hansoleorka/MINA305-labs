## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(lidR)
lasFile <- "data/frydenhaug/als2021.laz" # Filename
filter <- "-keep_xy 599850 6615750 600250 6616030 -keep_class 1 2" # ALS returns inside a boundary, only class 1 (unclassified), and 2 (ground)
lasdata <- readLAS(lasFile,filter=filter)
lasdz <- normalize_height(lasdata, tin())
las <- clip_circle(lasdz, 600080, 6615950, radius = sqrt(400/pi))
plot(las)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(las$X,las$Z,asp=1) #asp = setting the X Y axes equal
#Make pretty plot
source("R/laser.colors.R") # Reads in a predefined function 
plot(las$X,las$Z,asp=1,pch=".",col=laser.colors(las$Z)) #asp = setting the X Y axes equal
# Threshold of 2 m "The Nilsson rule" :-)
plot(las$X,las$Z,col=ifelse(las$Z>=2,"green","red"),asp=1,pch=".")
abline(h=2)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Hmean <- mean(las$Z[las$Z>=2])
Hmean # To print could also have used () before and after expression above


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(Hsd <- sd(las$Z[las$Z>=2]))

(Hcv <- Hsd/Hmean)

seq(0,1,0.05) # To create a sequence of numbers ?seq for info
q <- quantile(las$Z[las$Z>=2],probs=seq(0,1,0.05))
names(q) <- paste("H",seq(0,1,0.05)*100,sep="")
paste0("H",seq(0,1,0.05)*100)



## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ntot <- length(las$Z) # or nrow(las)
nabove <- length(las$Z[las$Z>=2])
(D0 = nabove/ntot)

ntot <- length(las$Z)# nrow(las)
H95 <- quantile(las$Z[las$Z>=2],probs=0.95)
layer <- (((H95 - 2)/10 )*9)+2
nabove <- length(las$Z[las$Z>=layer])
(D9 = nabove/ntot)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
layers <-  c(0:9)*(quantile(las$Z[las$Z >= 2], probs=0.95) - 2)/10 + 2
density.metrics <- c()
for(i in c(1:10)){
  ntot <- length(las$Z)# nrow(las)
  nabove <- length(las$Z[las$Z>=layers[i]])
  density.metrics[i] <- nabove/ntot
}
density.metrics



## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Filter first of many and single - 3 different ways to obtain the same result
names(las) # List the different attributes
first <- filter_first(las)
dim(first)
first <- filter_poi(las, ReturnNumber == 1)
dim(first)
first <- las[las$ReturnNumber == 1]
dim(first)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Filter last
last <- filter_last(las) #Last of many and single!!!!!
dim(last)
last <- filter_poi(las, ReturnNumber == NumberOfReturns & ReturnNumber != 1) # Only Last of many
dim(last)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
source("R/stdmetricsNOR.R") # Function computing point cloud metrics the after the Norwegian tradition [@Naesset2008-cd]
dat <- cloud_metrics(las,func=~stdmetricsNOR(Z))
data.frame(dat)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(lidR)
lasFile <- "data/vaaler/las/0008.las"
filter <- "-keep_xy 606200 6600150 606500 6600450" 
las <- readLAS(lasFile,filter=filter)
table(las$Classification)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lasdz <- normalize_height(las, tin())
table(lasdz$Classification)
lasdz_no_noise <- classify_noise(lasdz,algorithm=ivf(5,2)) # classify returns associated to noise in class 18
table(lasdz_no_noise$Classification)
lasdz_filtered <- filter_poi(lasdz_no_noise,Classification != 7 & Classification != 18) # 7 and 18: noise
plot(lasdz_filtered,color="Classification")
plot(lasdz_filtered)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
grd <- pixel_metrics(lasdz_filtered,func = ~stdmetricsNOR(Z),res=sqrt(250),filter= ~ReturnNumber == 1)
head(grd)
plot(grd)
plot(grd$H95)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ctg <- readLAScatalog("data/vaaler/las/")
plot(ctg)
ctg


## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ctg <- readLAScatalog("data/vaaler/las/")
# opt_filter(ctg) <- "-keep_classification 0 1 2"
# opt_output_files(ctg) <-  paste0("data/vaaler/dz/", "/{ORIGINALFILENAME}_norm")
# # Not run ctgdz <- normalize_height(ctg, tin())


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(sf)
library(lidR)
ctgdz <- readLAScatalog("data/vaaler/lasdz/")
plot(ctgdz)
st_layers("data/vaaler/sample_plots.gpkg") # list different layers in gpkg
sample_plots <- read_sf("data/vaaler/sample_plots.gpkg","field_plots")
head(sample_plots)
plot(sample_plots,add=T)


## ----message=FALSE,error=FALSE, warning=FALSE----------------------------------------------------------------------------------------------------------------------------------------------
#Function to process the las-catalog using the stdmetricsNOR function for each sample plot of 250 m^2
sqrt(250/pi) # Compute radius of plot 
plots <- plot_metrics(ctgdz, ~stdmetricsNOR(Z), sample_plots, radius = 8.92)
head(plots)

# #Example of 2 plots
# P1 <- lidR::clip_roi(ctgdz, sample_plots[sample_plots$ID=="P1",], radius = 8.92)
# P5 <- lidR::clip_roi(ctgdz, sample_plots[sample_plots$ID=="P5",], radius = 8.92)
# plot(P1)
# plot(P5)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
modTH <- lm(TH~H95,data=plots)
summary(modTH)
plot(plots$H95,plots$TH)
abline(coef(modTH))


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
modV <- lm(V~Hmean+D5,data=plots)
summary(modV)
plot(plots$Hmean,plots$V)


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(leaps)
library(ggplot2)
dat <- subset(plots, select=c(V,Hmax:Hcv,H10:D9))
dat <- st_drop_geometry(dat)
head(dat)
Xy <- log(dat)
mod <- lm(V~.,data=Xy)
summary(mod)

# Step wise model selection
stepmod <- step(mod,verbose=FALSE) 
summary(stepmod) # To many variables 

# Best subset nmax Indicate largest model
reg <- regsubsets(V~.,data=Xy,nvmax=3,really.big=TRUE) 
summary(reg)
mod <- lm(V~H70+D2,data=Xy)
summary(mod)

# Fitting the nonlinear version of the log-log model
mod <- nls(V~b0*H70^b1*D2^b2,data=dat,start=c(b0=1,b1=1,b2=1))
summary(mod)


## ----message=FALSE,error=FALSE, warning=FALSE----------------------------------------------------------------------------------------------------------------------------------------------
library(terra)
# opt_output_files(ctgdz) <- "data/vaaler/metrics/{ORIGINALFILENAME}_metrics" #Output directory NB files exist in downloaded data.
# metrics_w2w <- pixel_metrics(ctgdz, ~stdmetricsNOR(Z), res = sqrt(250), pkg = "terra")

rasters <- lapply(list.files("data/vaaler/metrics", full.names = T, pattern = ".tif$"), rast)
metrics_w2w <- do.call(mosaic, rasters)
plot(metrics_w2w)
#list.files()


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Do predictions 
library(terra)
plot(metrics_w2w$H95)
TH_pred <- predict(metrics_w2w, modTH) # Predicting top height
plot(TH_pred)
#Export predictions
#writeRaster(TH_pred,"data/TH.tif")


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(metrics_w2w$Hmean)
plot(metrics_w2w$D5)
V_pred <- predict(metrics_w2w, modV) # Predicting volume
plot(V_pred,zlim=c(0,500))
#writeRaster(V_pred,"data/V.tif")


## ----echo=FALSE,include=FALSE--------------------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("05_LabCode_AreaBasedApproach.Rmd")

