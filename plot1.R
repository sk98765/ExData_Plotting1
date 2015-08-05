
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

# Convert Global_active_power to numeric
dt2$Global_active_power <- as.numeric(dt2$Global_active_power)
# Get summary of Global_active_power
summary(dt2$Global_active_power)

with(dt2,plot(newdate,Global_active_power,type="l"))