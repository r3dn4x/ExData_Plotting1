#Download the data file

        if (!file.exists("data")){
                dir.create("data")
        }

        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./data/power.zip", method = "curl")
        unzip("./data/power.zip", exdir = "./data")

#Read the data file, select only the relevant dates and replace the Date and
#Time columns with a new DateTime column of the right date class.

        powerData <- read.table("./data/household_power_consumption.txt",
                        header = TRUE, sep = ";",
                        stringsAsFactors = FALSE)

        library(dplyr)          #Make sure the necessary packages are loaded.
        library(lubridate)

        data <- powerData %>% filter(Date == "1/2/2007" | Date == "2/2/2007") %>% 
                mutate(DateTime = dmy_hms(paste(Date, Time))) %>% 
                select(DateTime, c(3:9)) %>% 
                mutate_each(funs(as.numeric(.)), c(2:8))

#Plot four seperate graphs by first setting parameters for the number of rows
#and columns, the font size and the type. Then sequentially plot the graphs.
        
        par(mfrow = c(2,2), mar = c(4, 4, 2, 1), ps = 14, font.lab = 2)
        
        #1
        plot(data$DateTime, data$Global_active_power, xlab = "",
             ylab = "Global active power", type = "l")
        
        #2
        plot(data$DateTime, data$Voltage, type = "l", xlab = "DateTime",
             ylab = "Voltage")
        
        #3
        plot(data$DateTime, data$Sub_metering_1, type = "n", xlab = "",
             ylab = "Energy sub metering")
        points(data$DateTime, data$Sub_metering_1, type = "l")
        points(data$DateTime, data$Sub_metering_2, type = "l", col = "red")
        points(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2",
                                      "Sub_metering_3"),
               col = c("black", "red", "blue"), lwd = 1, cex = 0.85, bty = "n")
        
        #4
        plot(data$DateTime, data$Global_reactive_power, type = "l",
             xlab = "DateTime", ylab = "Global reactive power")

#Save the plot as a png file
        
        dev.copy(png, file = "plot4.png")
        dev.off()
