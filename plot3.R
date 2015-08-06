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

# Convert Sub_metering_1, Sub_metering_2 and Sub_metering_3 to numeric
df2$Sub_metering_1 <- as.numeric(df2$Sub_metering_1)
df2$Sub_metering_2 <- as.numeric(df2$Sub_metering_2)
df2$Sub_metering_3 <- as.numeric(df2$Sub_metering_3)

# Create a png device with 480x480 
png(filename = "plot3.png",width = 480, height = 480)

# Disable the label from axis ann=F
# Set up plot but don't draw type="n"
# Following code will determin which Sub_metering has the widest range 
#  then use this range to set up the plot, otherwise the plot
#  won't show anything beyond the range 
r1 <- range(df2$Sub_metering_1)
r2 <- range(df2$Sub_metering_2)
r3 <- range(df2$Sub_metering_3)
v <- c(r1[2],r2[2],r3[2])
ind <- which.max(v)
if (ind == 1) {
    with(df2,plot(datetime,Sub_metering_1,type="n",ann=FALSE))
 } else if (ind == 2) {
    with(df2,plot(datetime,Sub_metering_2,type="n",ann=FALSE))
 } else {
    with(df2,plot(datetime,Sub_metering_3,type="n",ann=FALSE))
 }

# Add Y-axis label to plot
title(ylab="Energy sub metering")
# Add data series to plot by using lines function
with(df2,lines(datetime,Sub_metering_1))
with(df2,lines(datetime,Sub_metering_2,col="red"))
with(df2,lines(datetime,Sub_metering_3,col="blue"))
# Create a legend for the plot at topright corner 
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_meterting_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1.5,1.5,1.5))
# Shut down the device       
dev.off()