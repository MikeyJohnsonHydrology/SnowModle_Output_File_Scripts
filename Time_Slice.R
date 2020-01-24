#####################################################################################################
### Full grid Time Slice for SnowModel (Function)
###
### This function creats a matrix of the entire SnowModel extent for a specifice time step and vairable
### 
### Written by: Mikey Johnson, University of Nevada Reno, < mikeyj@nevada.unr.edu >
### last eddited January 24, 2020
#####################################################################################################

### Sourcing functions to read .grad files ##########################################################
# this code sources the files from Marcos Longo's GitHub page
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/readctl.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/gridp.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/gridt.r")
source_url("https://raw.githubusercontent.com/mpaiao/ED2/master/R-utils/readgrads.r")

### Building the function ###########################################################################
Time_Slice <- function(filepath="snowpack.ctl",variable="swed",timestep){
  snowpack.info <- readctl(filepath)                      # Reading snowpack
  names <- snowpack.info$varname                          # Loading the variable names
  tmax <- snowpack.info$tmax
  
  if (variable %in% names == FALSE){
    print(c("Variable is not in .ctl file.  Available variables = ", paste(names, sep=",")))
  } else if ((timestep <= tmax & 0 < timestep) == FALSE){
    print(c("time step value is out of range", paste("Max Timestep =",tmax)))
  } else {
    dat <- readgrads(vari=variable,info=snowpack.info)      # Loading varable
    slice <- dat[[9]][timestep,1,,]                         # Time Slice
  }
}


### Example test function ###########################################################################
# test <- Time_Slice(filepath = "snowpack.ctl", variable = "swed", timestep = 183)


