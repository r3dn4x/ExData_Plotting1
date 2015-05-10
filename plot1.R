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
        
#Create the histrogram for Global_active_power
        
        hist(data$Global_active_power, main = "Global Active Power",
             xlab = "Global Active Power (Kilowatts)", ylab = "Frequency",
             col = "red")
        
#Save the graph as a png file
        
        dev.copy(png, file="plot1.png", height = 480, width = 480)
        dev.off()
        
        
        
                                                                   

