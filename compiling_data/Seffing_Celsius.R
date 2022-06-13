library(SEF)

x <- read.table("~/UniBe/Dove/UBERN04055.txt", fill=TRUE, stringsAsFactors=FALSE)
#x <- read.table("~/UniBe/Dove/UBERN09406.txt", fill=TRUE, stringsAsFactors=FALSE,sep=";")
#x <- read.table("~/UniBe/Dove/UBERN01498.txt", fill=TRUE, stringsAsFactors=FALSE,sep=";")
#x <- read.table("~/UniBe/Bern_Giub/Basel.csv", fill=TRUE, stringsAsFactors=FALSE,sep=";")

inventory <- read.csv("C:/Users/elinl/Documents/Inventory_EarlyInstrumentalData_Version_1.0_Clean.csv", sep=";", stringsAsFactors=F)
#inventory <- read.csv("Inventory_EarlyInstrumentalData_Version_1.0_Clean.csv", sep=";", stringsAsFactors=F)
index <- which(inventory$UBERN_ID=="UBERN04055")
lat <- inventory$Lat.degN.[index]
lon <- inventory$Lon.degE.[index]
alt <- inventory$Station_Elevation.m.[index]

x
years <- x[2:nrow(x), 1]
original_data <- unlist(c(t(x[2:nrow(x), 2:13]))) #transform matrix to vector
converted_data <- as.numeric(original_data) * 1.25 #convert from Reaumur to Celsius
#print(F)
#converted_data <- round((as.numeric(original_data)-32)/1.8,3) #convert from Fahrenheit to Celsius C = (F-32)/1.8
n <- length(converted_data)
df <- data.frame(y=rep(years,each=12), m=rep(1:12,nrow(x)-1), d=rep(1,n),
                 hh=rep("",n), mm=rep("",n), converted_data, stringsAsFactors=FALSE)

metadata <- x[1, 1:8]
meta_header <- paste0("Observation times=", metadata[7], "|Observer=", metadata[8])
meta_column <- paste0("orig=", original_data, metadata[3])
station_code <- paste(metadata[1],metadata[2],sep="_") # NB: station code cannot contain special characters and cannot be longer than 16 characters

write_sef(df, variable="ta", cod=station_code, nam=metadata[2], lat=lat,
          lon=lon, alt=alt, sou="Dove", units="C", stat="mean",
          metaHead=meta_header, meta=meta_column, period="month")
#write_sef(df, variable="ta", cod=station_code, nam=metadata[2], lat=metadata[4],
#          lon=metadata[5], alt=metadata[6], sou="Dove", units="F", stat="mean",
#         metaHead=meta_header, meta=meta_column, period="month")

#write_sef(df, variable="ta", cod=station_code, nam=metadata[2], lat=metadata[index],
#       lon=metadata[index], alt=metadata[index], sou="Dove", units="F", stat="mean",
#       metaHead=meta_header, meta=meta_column, meta=meta_row, period="month")

