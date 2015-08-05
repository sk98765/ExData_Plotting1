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

# Convert column
# Converting the missing value ? to NA
# Retrieve 2007-02-01 and 2007-02-02 data 
dt2 <- dt[dt$Date == "1/2/2007" | dt$Date == "2/2/2007",]
# Clean up dataset
rm(dt)

# Create a new column
dt2$datetime <- paste(dt2$Date,dt2$Time)

# Convert the datetime to POSIX
# The reason to convert datetime from character to POSIX is,
# POSIX actually is a integer number
dt2$datetime <- strptime(dt2$datetime,"%d/%m/%Y %H:%M:%S")

# Convert Sub_metering_1, Sub_metering_2 and Sub_metering_3 to numeric
dt2$Sub_metering_1 <- as.numeric(dt2$Sub_metering_1)
dt2$Sub_metering_2 <- as.numeric(dt2$Sub_metering_2)
dt2$Sub_metering_3 <- as.numeric(dt2$Sub_metering_3)

png(filename = "plot3.png",width = 480, height = 480)

# Disable the label from axis ann=F
# Set up plot but don't draw type="n"
#   Need consider to find out the largest range for Y-axis
r1 <- range(dt2$Sub_metering_1)
r2 <- range(dt2$Sub_metering_2)
r3 <- range(dt2$Sub_metering_3)
v <- c(r1[2],r2[2],r3[2])
ind <- which.max(v)
subsetstr <- paste("Sub_metering_",ind)

#with(dt2,plot(datetime,Sub_metering_1,type="n",ann=FALSE))

title(ylab="Energy sub metering")
with(dt2,lines(datetime,Sub_metering_1,type="l"))
with(dt2,lines(datetime,Sub_metering_2,type="l",col="red"))
with(dt2,lines(datetime,Sub_metering_3,type="l",col="blue"))
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_meterting_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1.5,1.5,1.5))
dev.off()