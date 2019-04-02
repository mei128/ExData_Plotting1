#
# plot3.R
#
# Time series of all 3 energy sub metterings

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
house <- mutate(house, datetime = as.POSIXct(paste(Date,Time)))

rm("baseDataURL","baseDataZIP","baseDataPath")

################### plot3- Time line of the 3 sub metterings ###############################
#                                                                                          #
# 1) Set locale to English so weekdays are printed in English                              #
# 2) Set up de PNG device (default is 480x480, but just to practice...)                    #
# 3) Draw an empty canvas as foundation to build on                                        #
# 4) Draw the lines with timestamp as X (3 times) and the three metterings a Y vector      #
# 5) Draw the legend                                                                       #
# 6) Close PNG device                                                                      #
#                                                                                          #
############################################################################################

Sys.setlocale("LC_ALL","English")

png(filename = "plot3.png", width = 480, height = 480, units = "px")

m1 <- house$Sub_metering_1
m2 <- house$Sub_metering_2
m3 <- house$Sub_metering_3
mv <- house[,6+mx]
xv <- house$datetime

plot(xv,m1, xlab = "", ylab = "Energy sub mettering", type = "n")

lines(xv, m1, col="black")
lines(xv, m2, col="red")
lines(xv, m3, col="blue")

legend("topright", legend = c("Sub_mettering_1","Sub_mettering_2","Sub_mettering_3"), lwd = c(1,1,1), col = c("black","red","blue"))

dev.off()

message("Your file is ready.")
