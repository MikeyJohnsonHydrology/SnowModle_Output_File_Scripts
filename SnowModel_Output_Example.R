##################################################################################################
### SnowModel_Output_Example.R
###
### This script sources Matlab scripts to read SnowModel GrADS files.
### To run this code you need: read_grads.m                      (Function to read GrADS files)
###                            read_SnowModel_save_data_swed.m   (Convert GrADS data to .txt files)
###                            read_SnowModel_slice_swed.m       (Save one specific day of data)
###                            read_SnowModel_swed.m             (Oringal readSnowModel.m code)
###                            read_SnowModel_time_series_swed.m (Save a time series for one gid-cell)
###                            swed.ctl                          (SnowModel output control file)
###                            swed.gdat                         (SnowModel output binary file)
###
### An aditional requiremtn is a working version of MatLab. This script will run the MatLab code
### throught the MacOS Terminal.
###
### Aditional test code to test MatLab runs are: Test_Save.m (Saves a .csv file)
###                                              test_matlab_run.txt (MacOS Terminal code to run Save_Test.m)
###
### By: Mikey Johnson, mikeyj@nevada.unr.edu, Last edited 2020-01-15
##################################################################################################

#### Loading packages ############################################################################
#These must be already installed on your system 
library(dplyr)      # data manipulation
library(ggplot2)    # plotting
library(cowplot)    # publication-ready plots
library(devtools)   # developer tools, simplifying tasks
library(raster)     # raster manipulation

### Setting the source file location #############################################################
sfl <- dirname(rstudioapi::getActiveDocumentContext()$path)  # this is the source file location of R-SnowModel.R
setwd(sfl)

### setting cube dimensions, assuming that all the files above come from the SnowModel run ###
x_max = 1121                                 # <-------------- change this different grid size
y_max = 759                                  # <-------------- change this different grid size
z_max = 366                                  # <-------------- change this different grid size


### dates and day of year ###
dates <-as.Date("2015-10-01") + 0:(z_max-1)    # <-------------- change this start date for different dates
day_of_water_year <- 1:z_max


### Run read_SnowModle_swed.m ####################################################################
system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('read_SnowModel_swed.m');exit;"`)))


### Run read_SnowModel_slice_swed.m ##############################################################
# Select day
day <- 170 # April 1

# Run matlab code
system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('read_SnowModel_slice_swed.m');exit;"`)))

# Read slice file
time_slice <- read.table("swed Time Slice Files/swed_slice_175.txt", header=F)


### Run read_SnowModel_time_series_swed.m ########################################################
# Select cell x,y
point <- c(10,10) # dimetions from the lower left corner

# Run matlab code
system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('read_SnowModel_time_series_swed.m');exit;"`)))

# Read time series file
time_series_swed <- read.delim("~/Desktop/swed_test_read/swed Singel-cell Time Series Files/swed_singel-cell_10,10.txt", header=FALSE)[1]
names(time_series_swed) <- c("SWE (m)")


### Run read_SnowModel_save_data_swed.m (Note: This take a long time to run) #####################
# Run Matlab code
system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('read_SnowModel_data_cube_save_swed.m');exit;"`)))

# Read Data Cube
SWED_Files <- list.files("swed Data Cube Files")
SWED_Files <- SWED_Files[order(nchar(SWED_Files), SWED_Files)]

SWED_data_cube <- array(rep(NA,y_max*x_max*z_max), c(y_max,x_max,z_max))

for(i in 1:z_max){
  SWED_data_cube[,,i] <- as.matrix(read.table(paste0("swed Data Cube Files/",SWED_Files[i]), header=FALSE))
}






### Test code to Run a Matlab script
sfl <- dirname(rstudioapi::getActiveDocumentContext()$path)  # this is the source file location of R-SnowModel.R
setwd(sfl)

# Test code to run MATLAB
system('/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "a=2; b=1; display(a+b); exit"') # This works well and fast

# Terminal Code to run matlab
# /Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('Desktop/swed_test_read/Test_Save.m');exit;"    This works in the termanal buap buap buap

# R code to run terminal code to run matlab (Note: Need to set my working directory)
#system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('Desktop/swed_test_read/Test_Save.m');exit;"`)))
system(deparse(substitute(`/Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -r "run('Test_Save.m');exit;"`)))

# Source a text file to run Matlab
system("sh test_matlab_run.txt")
