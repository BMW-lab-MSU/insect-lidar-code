rm(list=ls())
#sdir <- "F:/Data/MsuLidar/20160608/AMK_Ranch-212629/AMK_Ranch-212629/" # where be the data?
sdir <- "/Users/elizabethrehbein/Documents_HD/Insect Lidar/data/2016-06-08/pt_normalized" # where be the data?
psplit <- strsplit(sdir,"/")[[1]]
sdlen <- length(psplit)
sdirt <- psplit[sdlen] # pasting together the path for output file names
library(data.table) # a faster form of data.frame, sharing many properties; indexing is different
library(Cairo) # nicer PDF
library(rsvd) # faster function: implements stochastic algorithm
library(R.matlab)
library(DepthProc)
flist <- dir(path=sdir,patt="00.+mat",recursive=T) # list all files in directory matching the pattern
