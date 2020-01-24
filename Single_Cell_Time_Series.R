#####################################################################################################
### Single Cell Time Series for SnowModel (Function)
###
### This function organizes a timeseries of all the variables in a .grads file from SnowModel.
### 
### Written by: Mikey Johnson, University of Nevada Reno, < mikeyj@nevada.unr.edu >
### last eddited 01-23-2020
#####################################################################################################

### Sourcing functions to read .grad files ##########################################################
# this code sources the files from Marcos Longo's GitHub page
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/readctl.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/gridp.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/gridt.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/readgrads.r")

### Building the function ###########################################################################
Single_Cell_Timeseries <- function(filepath="snowpack.ctl",x=1,y=1){
  
  snowpack.info <- readctl(filepath)                     # Reading snowpack
  names <- snowpack.info$varname
  dates <- snowpack.info$gtime
  df <- data.frame(matrix(NA, nrow = length(dates), ncol = 1 + length(names)))
  df[,1] <- dates
  
  for (i in 1:length(names)){
    dat <- readgrads(vari=names[i],info=snowpack.info)
    df[,i+1] <- dat[[9]][,1,x,y]
  }
  
  names(df) <- c("Date/Time",names)
  return(df)
}

### Example of how to run the function #########################
#df <- Single_Cell_Timeseries("snowpack.ctl",1,1)
