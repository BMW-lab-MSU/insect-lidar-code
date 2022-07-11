rm(list=ls())
#sdir <- "F:/Data/MsuLidar/20160608/AMK_Ranch-212629/AMK_Ranch-212629/" # where be the data?
sdir <- "/Users/elizabethrehbein/Documents_HD/Insect Lidar/data/2016-06-08/rpca_data/" # where be the data?
psplit <- strsplit(sdir,"/")[[1]]
sdlen <- length(psplit)
sdirt <- psplit[sdlen] # pasting together the path for output file names
library(data.table) # a faster form of data.frame, sharing many properties; indexing is different
library(Cairo) # nicer PDF
library(rsvd) # faster function: implements stochastic algorithm
library(R.matlab)
library(DepthProc)
clrs <- colorRampPalette(rev(c("orange","purple")))(100) # set color palette avoiding red-green
flist <- dir(path=sdir,patt=".+mat",recursive=T) # get all mat files
#flist <- dir(path=sdir,patt="00.+mat",recursive=T) # list all files in directory matching the pattern
#ix<-grep(patt="raw",flist) # identifies data with "raw" in the title
#flist<-flist[-ix] 
#ix<-grep(patt="processed",flist)   # what's this do?
#flist<-flist[-ix]   #what's this do?
rngZlim <- c(0,0)   #what's this do?
for (fl in flist){
  #pt_data <- readMat(paste(sdir,fl,sep=""))$full.data # reading in raw .mat data --> need to modify to take normalized data
  pt_data <- readMat(paste(sdir,fl,sep="")) #gets the dataset of specific pan/tilt vectorized data
  # ADD LOOP HERE TO DIVE INTO pt_data
  pt_data<-pt_data$norms[2]
  pt_data <- sweep(pt_data,1,depthMedian(t(pt_data)))
  print(system.time(rp <- rrpca(pt_data))) #displays execution time, very slow!
  # Need to us fl to create folder
  png(filename=paste("/Users/elizabethrehbein/Documents_HD/Insect Lidar/data/2016-06-08/rpca_data",
      sub(patt="/",repl="_",x=sub(patt="\\.mat",repl="",x=fl)),".png",sep=""),
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