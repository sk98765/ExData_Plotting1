
# The data file is called household_power_consumption.txt
# Set the fileName points to household_power_consumption.txt
zipfileName <- "exdata_data_household_power_consumption.zip"
fileName <- "household_power_consumption.txt"
# (getwd())
fileexist <- file.exists(fileName)
(fileexist)

if (! fileexist) {
    # check to see if zipped data file is available
    if (! file.exists(zipfileName)) {
        # Retrieve the file from web
        print("Retrieving file from web")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl,zipfileName)
        # unzip file 
        unzip(zipfileName)
        if (file.exists(fileName))
            print("data file available")
    }
} else
    print("data file available")

# Use read.table to read in the data set 
# Read in header too and separator is ";"
# Read in everything as character
dt <- read.table(fileName,header = T,sep=";",colClasses = "character")

# Check first few row of data
head(dt)

# Find out how many observations and how many variabls
dim(dt)

# Find out the data structure for the variables
str(dt)

# Retrieve 2007-02-01 and 2007-02-02 data
dt2 <- dt[dt$Date == "1/2/2007" | dt$Date == "2/2/2007",]

# Clean up dataset
rm(dt)

# Create a new column
dt2$datetime <- paste(dt2$Date,dt2$Time)

# Convert the datetime to POSIX
# The reason to convert newdate from character to POSIX is,
# POSIX actually is a integer number
dt2$datetime <- strptime(dt2$datetime,"%d/%m/%Y %H:%M:%S")

# Convert Global_active_power to numeric
dt2$Global_active_power <- as.numeric(dt2$Global_active_power)
# Get summary of Global_active_power
summary(dt2$Global_active_power)

png(filename = "plot1.png",width = 480, height = 480)

hist(dt2$Global_active_power,ann=FALSE,col="red")
title(xlab="Global Active Power (kilowatts)",
      ylab="Frequency",
      main="Global Active Power")
dev.off()