## -----------------------------------------------------------------------------------------------------------
library(sf)
g <- read_sf("data/lab1_my.gpkg") #Read your digitized polygons
g$ID <- c(1:nrow(g)) #Create a unique ID for each polygon (record/row)
plot(g["Type"]) #Plot the attribute (Column) containing the land cover types. 
ar5 <- read_sf("data/lab1.gpkg","ar5") #Read the Norwegian land cover dataset AR5 (Arealressurskart 1:5000) 
plot(st_geometry(ar5)) #Plot only the geometry (outline) of this


## -----------------------------------------------------------------------------------------------------------
g <- st_transform(g,st_crs(ar5)) # project coordinat system of your polygons to the same system as ar5 - land cover dataset. 
int <- st_intersection(ar5,g) #If error see below
plot(st_geometry(int))


## -----------------------------------------------------------------------------------------------------------
library(terra) #Load the terra package if you not install you need to install it (install.packages())
# Sentinel 2
s2 <- rast("data/sentinel2A.tif")
plot(s2)
plotRGB(s2, r=3, g=2, b=1, stretch="hist")


## -----------------------------------------------------------------------------------------------------------
#If you have a older version you need to convert the sf object into a terra vector data
#g <- vect(g)
e <- extract(s2,g) # Extract information 
head(e)
g2 <- merge(g,e,by="ID") #Merge the two tables into one using ID
g2$Type <- as.factor(g2$Type) # Convert to factor i.e. categorical variable in R
head(g2)


## -----------------------------------------------------------------------------------------------------------
library(randomForest)
rf1 <- randomForest(Type~Blue+Green+Red+NIR,data=g2)
pred <- predict(s2,rf1)
plot(pred)
#writeRaster(pred,"data/lab1/classification.tif") # Save to disk (# means that it is commented out and will not be run, remove # to save on disk)


## -----------------------------------------------------------------------------------------------------------
dat <- st_drop_geometry(g2[,-1])
head(dat)
library(MASS)
lda1 <- lda(Type~.,data=dat)
pd <- function(lda1,..){predict(lda1,..)$class}
pred <- predict(s2,lda1,fun=pd)
plot(pred)
#writeRaster(pred,"data/lab1/classification_planet2.tif")


## -----------------------------------------------------------------------------------------------------------
library(dplyr)
pkt <- st_sample(ar5,size=1000) # Random sample of points within the ar5 dataset
pkt <- st_intersection(ar5 %>% dplyr::select(IPCC,geom),pkt) #Intersection with ar5 i.e. extract teh IPCC - value 
head(pkt)
e <- extract(pred,vect(pkt)) #Extract predicted value from the pixel at the point location
pkt <- cbind(pkt,e[,-c(1)]) #Combine 
names(pkt)[2] <- "Predicted"
head(pkt)
pkt$Reference <- substr(pkt$IPCC,1,1)
pkt$Predicted <- factor(pkt$Predicted,labels=unique(pkt$Reference),levels=unique(pkt$Reference))
pkt$Reference <- factor(pkt$Reference,labels=unique(pkt$Reference),levels=unique(pkt$Reference))
#Create errormatrix
em <- xtabs(~Predicted+Reference,data=pkt,addNA=T)
em
sum(diag(em)) / sum(em)


## ----echo=FALSE,include=FALSE-------------------------------------------------------------------------------
knitr::purl("01_datasources.Rmd")

