#
# plot4.R
#
# Quadruple chart

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

house <- read_delim(baseDataPath, delim=";", na = "?", col_types= cols(col_date(format = "%d/%m/%Y"),
                       col_time(format = "%H:%M:%S"), col_double(), col_double(), col_double(),
                        col_double(), col_double(), col_double(), col_double()))

house <- filter(house,Date=="2007-2-1"|Date=="2007-2-2")
house <- mutate(house, datetime = as.POSIXct(paste(Date,Time)))

rm("baseDataURL","baseDataZIP","baseDataPath")

################### plot4- Quadruple Chart #################################################
#                                                                                          #
# 1) Set locale to English so weekdays are printed in English                              #
# 2) Set up de PNG device (default is 480x480, but just to practice...)                    #
# 3) Use the par() function to arrange a 2x2 space                                         #
# For each chart                                                                           #
# 5.1) Draw an empty canvas as foundation to build on                                      #
# 5.2) Draw the lines with X = datetime and Y = required measurment                        #
# 5.3) Draw the legend if needed                                                           #
# 6) Close PNG device                                                                      #
#                                                                                          #
############################################################################################

Sys.setlocale("LC_ALL","English")

png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfcol = c(2,2))

# Upper left - Global Active Power

with(house, {
    plot(datetime,Global_active_power, xlab = "", ylab = "Global Active Power", type = "n")
    lines(datetime,Global_active_power)
})

# Lower left - Sub metterings

with(house, {
    plot(datetime,Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n")
    lines(datetime,Sub_metering_1, col="black")
    lines(datetime,Sub_metering_2, col="red")
    lines(datetime,Sub_metering_3, col="blue")
})
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lwd = c(1,1,1), col = c("black","red","blue"), bty="n")

# Upper right - Voltage

with(house, {
    plot(datetime,Voltage,type = "n")
    lines(datetime,Voltage)
})

# Lower right - Global Reactive Power

with(house, {
    plot(datetime,Global_reactive_power,type = "n")
    lines(datetime,Global_reactive_power)
})


dev.off()

message("Your file is ready.")
