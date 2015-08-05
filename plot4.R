
# The data file is called household_power_consumption.txt
# Set the fileName points to household_power_consumption.txt
fileName <- "household_power_consumption.txt"
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

# Convert column
# Converting the missing value ? to NA
# dt$Global_active_power[dt$Global_active_power == "?"] <- NA
# Retrieve 2007-02-01 data
feb1 <- dt[dt$Date == "1/2/2007",]
# Retrieve 2007-02-02 data
feb2 <- dt[dt$Date == "2/2/2007",]

# Combine feb1 and feb2 to become the base dataset 
dt2 <- rbind(feb1,feb2)

# Clean up dataset
rm(dt)

# Create a new column
dt2$datetime <- paste(dt2$Date,dt2$Time)

# Convert the newdate to POSIX
# The reason to convert newdate from character to POSIX is,
# POSIX actually is a integer number
dt2$datetime <- strptime(dt2$datetime,"%d/%m/%Y %H:%M:%S")

# Convert Global_active_power to numeric
dt2$Global_active_power <- as.numeric(dt2$Global_active_power)

dt2$Voltage <- as.numeric(dt2$Voltage)

dt2$Global_reactive_power <- as.numeric(dt2$Global_reactive_power)

dt2$Sub_metering_1 <- as.numeric(dt2$Sub_metering_1)
dt2$Sub_metering_2 <- as.numeric(dt2$Sub_metering_2)
dt2$Sub_metering_3 <- as.numeric(dt2$Sub_metering_3)

# Get summary of Global_active_power

png(filename = "plot4.png",width = 480, height = 480)

# Create 2 row 2 column panel
par(mfrow=c(2,2))

with(dt2,plot(datetime,Global_active_power,type="l",ann=FALSE))
title(ylab="Global Active Power")

with(dt2,plot(datetime,Voltage,type="l",ann=TRUE))

with(dt2,plot(datetime,Sub_metering_1, ann=FALSE, type="n"))
title(ylab="Energy sub metering")
with(dt2,lines(datetime,Sub_metering_1,type="l"))
with(dt2,lines(datetime,Sub_metering_2,type="l",col="red"))
with(dt2,lines(datetime,Sub_metering_3,type="l",col="blue"))
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_meterting_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1))

with(dt2,plot(datetime,Global_reactive_power,type="l",ann=TRUE))

dev.off()