#
# plot1.R
#
# Histogram of Global Active Power

library(readr)
library(dplyr)

################### Common to all scripts - simpler than sourcing for grading ##############
#                                                                                          #
# 1) Download and expand this project's base data (if it has not been done already).       #
# 2) Read data from delimited file (use readr pakage for convenience)                      #
# 3) Filter to keep the two selected dates (Feb 1 and 2, 2007)                             #
# 4) Add timestamp variable (DateTime) combining Date and Time                             #
#                                                                                          #
############################################################################################

baseDataURL     <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
baseDataZIP     <- "./baseData.zip"
baseDataPath    <- "./data/household_power_consumption.txt"
    
if (!file.exists(baseDataPath)) {
    download.file(baseDataURL,destfile = baseDataZIP, method = "curl")
    unzip(baseDataZIP,exdir = "./data")
    file.remove(baseDataZIP)
}

house <<- read_delim(baseDataPath, delim=";", na = "?", col_types= cols(col_date(format = "%d/%m/%Y"),
                       col_time(format = "%H:%M:%S"), col_double(), col_double(), col_double(),
                        col_double(), col_double(), col_double(), col_double()))

house <- filter(house,Date=="2007-2-1"|Date=="2007-2-2")
house <- mutate(house, DateTime = as.POSIXct(paste(Date,Time)))

rm("baseDataURL","baseDataZIP","baseDataPath")

################### plot1 - Histogram of Global_active_power ###############################
#                                                                                          #
# 1) Set up de PNG device (default is 480x480, but just to practice...)                    #
# 2) Draw histogram with desired parameters and labels                                     #
# 3) Close PNG device                                                                      #
#                                                                                          #
############################################################################################

png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(house$Global_active_power, main = "Global Active Power",
                                xlab = "Global Active Power (kilowatts)",
                                col = "red")
dev.off()

