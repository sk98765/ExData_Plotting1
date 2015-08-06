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

# Get summary of Global_active_power
summary(df2$Global_active_power)

# Create a png device with 480x480 
png(filename = "plot2.png",width = 480, height = 480)

# Create scatter plot using newdate as x-axis and Global_active_pwer as Y-axis
# Type of graph is line
with(df2,plot(datetime,Global_active_power,type="l",
              ann=FALSE))
# Add label to Y-axis     
title(ylab="Global Active Power (kilowatts)")
# Shut down the device and flush all the information to png file
dev.off()