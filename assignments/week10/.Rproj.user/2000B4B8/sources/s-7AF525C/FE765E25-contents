# IST659 Lab10

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# Ready RODBC for use in this script
# Required Libraries
if(!require(RODBC)){install.packages("RODBC")}

# Create a connection to SQL Server using our 64-bit DSN
myconn <- odbcConnect('VidCast64')

# Ready the SQL to send to the Server
sqlSelectStatement <-
  "SELECT
    vc_VidCast.vc_VidCastID,
    vc_VidCast.VidCastTitle,
    DatePart(dw, StartDateTime) as StartDayofWeek,
    DATEDIFF(n, StartDateTime, EndDateTime) as ActualDuration,
    ScheduleDurationMinutes
FROM vc_VidCast
WHERE DATEDIFF(n, StartDateTime, EndDateTime) <= 300
Order BY ActualDuration DESC
"
# Send the request to the server and store the results in a variable
sqlResult <- sqlQuery(myconn,sqlSelectStatement)

# Create a list of days of the week for charting
days <- c("Sun","Mon","Tues","Weds","Thurs","Fri","Sat")

# Create a histogram of durations
hist(sqlResult$ActualDuration,
     main="RTIMBROO How long are the VidCasts?",
     xlab="Minutes",
     ylab="VidCasts",
     border="blue",
     col="grey",
     labels=TRUE
)

# Plot a bar chart of video counts by day of the week
dayCounts <- table(sqlResult$StartDayofWeek)
barplot(dayCounts,
        main="RTIMBROO VidCasts by Day of Week",
        ylab="Day of Week",
        xlab="Count of VidCasts",
        border="blue",
        names.arg = days
)

# close all connections
odbcCloseAll()






