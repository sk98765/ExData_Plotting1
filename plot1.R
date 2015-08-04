
# The data file is called household_power_consumption.txt
# Set the fileName points to household_power_consumption.txt
fileName <- "household_power_consumption.txt"
# Use read.table to read in the data set 
# Read in header too and separator is ";"
dt <- read.table(fileName,header = T,sep=";",colClasses = "character")

# Check first few row of data
head(dt)

# Find out how many observations and how many variabls
dim(dt)

# Find out the data structure for the variables
str(dt)

# Converting the missing value ? to NA
dt$Global_active_power[dt$Global_active_power == "?"] <- NA
# Retrieve 2007-02-01 data
feb1 <- dt[dt$Date == "1/2/2007"]
# Retrieve 2007-02-02 data
feb2 <- dt[dt$Date == "2/2/2007"]

# Combine feb1 and feb2 to become the base dataset 
dt2 <- rbind(feb1,feb2)

# Remove the original dataset to free memory
rm(dt)

# Change date format
# %Y - 4 digit year
dt2$Date <- as.Date(dt2$Date,"%d/%m/%Y")





