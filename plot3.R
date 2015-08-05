
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
dt2$newdate <- paste(dt2$Date,dt2$Time)

# Convert the newdate to POSIX
# The reason to convert newdate from character to POSIX is,
# POSIX actually is a integer number
dt2$newdate <- strptime(dt2$newdate,"%d/%m/%Y %H:%M:%S")

# Convert Sub_metering_1, Sub_metering_2 and Sub_metering_3 to numeric
dt2$Sub_metering_1 <- as.numeric(dt2$Sub_metering_1)
dt2$Sub_metering_2 <- as.numeric(dt2$Sub_metering_2)
dt2$Sub_metering_3 <- as.numeric(dt2$Sub_metering_3)

# Get summary of Sub_metering
# summary(dt2$Sub_metering_1)
# summary(dt2$Sub_metering_2)
# summary(dt2$Sub_metering_3)

png(filename = "plot3.png",width = 480, height = 480)

# change the margin of the plot to hide xlab 
# bottom lines is the first one in c(bottom,left,top,right)
with(dt2,plot(newdate,Sub_metering_1,type="n",ann=FALSE))
title(ylab="Energy sub metering")
with(dt2,lines(newdate,Sub_metering_1,type="l"))
with(dt2,lines(newdate,Sub_metering_2,type="l",col="red"))
with(dt2,lines(newdate,Sub_metering_3,type="l",col="blue"))
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_meterting_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1.5,1.5,1.5))
dev.off()