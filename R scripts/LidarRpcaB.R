rm(list=ls())
sdir <- "F:/Data/MsuLidar/20160608/AMK_Ranch-212629/AMK_Ranch-212629/" # where be the data?
psplit <- strsplit(sdir,"/")[[1]]
sdlen <- length(psplit)
sdirt <- paste(psplit[sdlen]) # pasting together the path for output file names
library(data.table) # a faster form of data.frame, sharing many properties; indexing is different
library(Cairo) # nicer PDF
library(rsvd) # faster function: implements stochastic algorithm
library(R.matlab)
library(DepthProc)
clrs <- colorRampPalette(rev(c("orange","purple")))(100) # avoiding red-green
flist <- dir(path=sdir,patt="*.",recursive=T)
rngZlim <- c(0,0)
for (fl in flist){
  nv <- readMat(paste(sdir,fl,sep=""))$full.data
  nv <- sweep(nv,1,depthMedian(t(nv)))
  print(system.time(rp <- rrpca(nv))) #displays execution time, very slow!
  png(filename=paste("f:/data/",sdirt,'/',sub(patt="\\.mat",repl="",basename(fl)),".png",sep=""),
      width=6*1.78,height=5.12,units="in",res=144) # set up the output graphic file
  par(mfrow=c(1,3),oma=c(0,0,2,0),mar=c(2.1,2.1,0,0.1))
  image(rp$L,col=clrs)
  backgroundStdDev <- sqrt(apply(rp$L,1,var)) # calculating the standard deviation of the low rank (background) approximation
  targets <- rp$S
  image(targets,col=clrs) # color scaled image of the targets
  targets <- sweep(x=targets,MARGIN=1,STATS=backgroundStdDev,FUN="/") # rescaling the sparse, outlier matrix using that standard deviation
  image(targets,col=clrs) # color scaled image of the targets
  rng <- range(targets)
  rngZlim[1] <- min(rngZlim,rng[1]); rngZlim[2] <- max(rngZlim[2],rng[2])
  print(rngZlim)
  title(paste(sdirt,fl,paste(rng,collapse="  "),sep="  "),cex.main=0.5,outer=T)
  dev.off() # closing the output graphic file
}