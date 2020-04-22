#####################################################################################################
### Slice to Raster, Function
###
### This code turns a SnowModel times slice (2D matrix) to a raster (.tiff)
### 
### Code By: Mikey Johnosn, mikeyj@nevada.unr.edu
### Last Edited: April 21, 2020
#####################################################################################################

### Loading Libraries ###############################################################################
library(raster)


### Defining the function ###########################################################################
slice_to_raster <- function(slice = matrix(runif(1121*759),759,1121),           # example data source
                            cell_size = 100,
                            llc_x = 489747,
                            llc_y = 4853924,
                            crs_string="+proj=utm +zone=10 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
                            ){
  ### Fliping the slice about the y-axes
  Slice <- as.matrix(slice)
  Slice <- apply(Slice, 2, rev)  

  nx = as.numeric(ncol(Slice))
  ny = as.numeric(nrow(Slice))

### Making a list of all the raster values
  dat1=list()
  dat1$x=seq(llc_x, by=cell_size, len=nx+1)       # xmn,deltax,nx+1 = nx max
  dat1$y=seq(llc_y, by=cell_size, len=ny+1)       # ymn,deltay,ny+1 = ny max
  dat1$z=Slice                                    # real data from slice
  
  
  out.raster <-raster(                             # Building a Raster
    dat1$z,
    xmn=range(dat1$x)[1], xmx=range(dat1$x)[2],
    ymn=range(dat1$y)[1], ymx=range(dat1$y)[2], 
    crs=CRS(crs_string)
  )
  return(out.raster)
} 


### Function Test ###################################################################################
#test1 <- slice_to_raster()
#plot(test1)


#sfl <- dirname(rstudioapi::getActiveDocumentContext()$path)  # this is the source file location
#setwd(paste(sfl,"Example_Data","Test_Save_Raster", sep="/"))
#April_1_Slice <- read.table("Time_Slice.txt", header=FALSE)
#test <- slice_to_raster(slice = April_1_Slice)
#plot(test)


