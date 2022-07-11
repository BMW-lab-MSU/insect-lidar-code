rm(list=ls()) # clear all variables

#sdir <- "C:/Users/KFristrup/Desktop/GRTE/2018-07-07/" # where be the data?
sdir <- "/Users/elizabethrehbein/Documents_HD/Insect_Lidar/data/2016-06-08/processed_data" #location of the data

psplit <- strsplit(sdir,"/")[[1]]
sdlen <- length(psplit)
sdirt <- paste(psplit[(sdlen-1):sdlen],collapse='_') # pasting together the path for output file names; I was preparing to process multiple subdirectories, but never implemented this
library(data.table) # a faster form of data.frame, sharing many properties; indexing is different
#library(Cairo) # nicer PDF
library(rpca) # implementation of Candes's Robust PCA; decompose X into L + S, L is low-rank, S is sparse
library(rNMF) # one of several non-negative matrix factorization packages, another option for processing
clrs <- colorRampPalette(rev(c("orange","purple")))(100) # avoiding red-green
flist <- dir(path=sdir,patt="*.",recursive=T)
for (fl in flist)
  nv <- as.matrix(fread(input=paste(sdir,fl,sep="")),sep=',') # rows are range bins, columns are shots
  nv <- sweep(x=nv,MARGIN=2,STATS=colMeans(nv)) # subtract the mean value from each shot; substantial variation: ?laser varies in intensity per shot?
  print(system.time(rp <- rpca(nv))) # rpca calculation, wrapped to display execution time, very slow!
  backvar <- sqrt(apply(rp$L,1,var)) # calculating the standard deviation of the low rank (background) approximation; fluttering vegetation?
  targets <- sweep(x=rp$S,MARGIN=1,STATS=backvar,FUN="/") # rescaling the sparse, outlier matrix using that standard deviation
  png(filename=paste("d:/lidar/",sdirt,'_',sub(patt="/.*",repl="",dirname(fl)),"_",
                     sub(patt="\\.csv",repl="",basename(fl)),".png",sep=""),
      width=4*1.78,height=5.12,units="in",res=144) # set up the output graphic file
  image(targets,col=clrs) # color scaled image of the targets
  title(paste(sdirt,fl,sep="_"))
  dev.off() # closing the output graphic file
