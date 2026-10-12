stdmetricsNOR = function(Z, th = 2, distpre="H",denspre="D"){
  
  z <- Z
  
  ################
  #DENSITY METRICS
  ctv = function(z){quantile(z[z>=th],probs=0.95,type=2)}
  DensityMetrics <- function(z){
    if(is.na(ctv(z))==FALSE){
      k<-vector()
      for (i in 0:9){
        k<-cbind(k,(length(z[z >= th+((ctv(z)-th)/10)*i])/length(z)))
      }
      k<-as.numeric(k)
    }
    else{ k <- rep(0,10) }
  }
  
  d <- DensityMetrics(z)
  names(d) = paste0(denspre, 0:9)
  
  
  ###############
  #HEIGHT METRICS
  probs = c(seq(0.1,0.9,0.1),0.95)
  zq 	  = as.list(stats::quantile(z[z>=th], probs))
  names(zq) = paste0(distpre, probs*100)
  
  skewness<-function(z){
    m3<-sum((z-mean(z[z>=th]))^3)/length(z[z>=th])
    s3<-sqrt(var(z[z>=th]))^3
    m3/s3
  }
  kurtosis<-function(z){
    m4<-sum((z[z>=th]-mean(z[z>=th]))^4)/length(z[z>=th])
    s4<-var(z[z>=th])^2
    m4/s4 - 3
  }
  coefvar<-function(z){
    sd(z[z>=th])/mean(z[z>=th])
  }
  
  metrics = list(
    max  = max(z[z>=th]),
    mean = mean(z[z>=th]),
    sd   = stats::sd(z[z>=th]),
    cv   = coefvar(z[z>=th]),
    kurt = kurtosis(z[z>=th]),
    skewness = skewness(z[z>=th])
  )
  names(metrics) <- paste0(distpre,gsub("[%]","",names(metrics)))
  
  
  
  metrics = c(metrics, zq, d)
  
  return(metrics)
}
