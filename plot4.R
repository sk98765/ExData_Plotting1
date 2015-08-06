# The data file is called household_power_consumption.txt
# Set the fileName points to household_power_consumption.txt
zipfileName <- "exdata_data_household_power_consumption.zip"
fileName <- "household_power_consumption.txt"
fileexist <- file.exists(fileName)
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

# Read dataset into a data frame using read.table with following options
# header = TRUE, sep=";", colClasses = "character"
df <- read.table(fileName,header = T,sep=";",colClasses = "character")

# Check first few row of data
head(df)

# Find out how many observations and how many variabls
dim(df)

# Find out the data structure for the variables
str(df)

# For this assignment we only care for 2007-02-01 and 2007-02-02 
# Retrieve 2007-02-01 and 2007-02-02 data from the whole data set 
df2 <- df[df$Date == "1/2/2007" | df$Date == "2/2/2007",]

# Clean up dataset
rm(df)

# Create a new column by combining Date and Time together
df2$datetime <- paste(df2$Date,df2$Time)

# Convert the datetime to POSIX, so we can use this new column to 
# create time series plot
df2$datetime <- strptime(df2$datetime,"%d/%m/%Y %H:%M:%S")

# Convert Global_active_power to numeric
df2$Global_active_power <- as.numeric(df2$Global_active_power)

df2$Voltage <- as.numeric(df2$Voltage)

df2$Global_reactive_power <- as.numeric(df2$Global_reactive_power)

df2$Sub_metering_1 <- as.numeric(df2$Sub_metering_1)
df2$Sub_metering_2 <- as.numeric(df2$Sub_metering_2)
df2$Sub_metering_3 <- as.numeric(df2$Sub_metering_3)

# Get summary of Global_active_power

png(filename = "plot4.png",width = 480, height = 480)

# Create 2 row 2 column panel
par(mfrow=c(2,2))

with(df2,plot(datetime,Global_active_power,type="l",ann=FALSE))
title(ylab="Global Active Power")

with(df2,plot(datetime,Voltage,type="l",ann=TRUE))

with(df2,plot(datetime,Sub_metering_1, ann=FALSE, type="n"))
title(ylab="Energy sub metering")
with(df2,lines(datetime,Sub_metering_1,type="l"))
with(df2,lines(datetime,Sub_metering_2,type="l",col="red"))
with(df2,lines(datetime,Sub_metering_3,type="l",col="blue"))
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_meterting_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1))

with(df2,plot(datetime,Global_reactive_power,type="l",ann=TRUE))

dev.off()