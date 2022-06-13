library(dataresqc)
library(reader)
library(stringr)

setwd("C:/Users/elinl/Documents/UniBe/Instrumentelle data/Russian")
outpath = "C:/Users/elinl/Documents"
#out_path
setwd("C:/Users/elinl/Documents/UniBe/Instrumentelle data/Inventories")
y <- read.table("Inventory_Russia.txt", header=FALSE, sep="\t", encoding="UTF-8",
                stringsAsFactors=FALSE, fill = TRUE, quote="",comment.char = "%")


inv <- data.frame(station=y$V1, 
                  name=trimws(y$V2),
                  src=y$V3,
                  lat=y$V4,
                  lon=y$V5,
                  ele=y$V6,
                  stringsAsFactors=FALSE)

inv$file_id <- paste0(inv$station,".txt")
var <- "ta"
unit <- "C"
stat <- "mean"
period <- "month"
sou <- "meteo.ru"
link <- "http://meteo.ru/english/climate/cl_data.php; http://aisori.meteo.ru/ClimateE"

setwd("C:/Users/elinl/Documents/UniBe/Instrumentelle data/Russian/Temperatur")
files <- list.files(pattern=".txt",full.names = FALSE)

# for (f in files) {
#   x <- read.table(f, header=FALSE, sep="\t", stringsAsFactors=FALSE, skip = 1,
#                   fill = TRUE, quote="",comment.char = "%", blank.lines.skip = TRUE)
#   if (any(is.na(x[,1]))) {
#     print(f)
#     z <- x
#   }
# }

for (f in files) {
  
  #f <- files[2]
  x <- read.table(f, header=FALSE, sep="\t", stringsAsFactors=FALSE, skip = 1,
                  fill = TRUE, quote="",comment.char = "%", blank.lines.skip = TRUE)
  
  x <- x[!is.na(x$V1),]
  n <- ncol(x)-1
  days <- hours <- minutes <- rep("", n*nrow(x))
  
  
  out <- data.frame(year = rep(as.integer(x[,1]), each=n), 
                    month = rep(1:n, nrow(x)), 
                    day = days, 
                    hour = hours, 
                    minute = minutes,
                    value = as.numeric(c(t(x[,2:ncol(x)]), recursive=TRUE)))
  #out <- out[!is.na(out$year),]
  #out <- out[out$year >= 1600,]
  
  write_sef(out,
            outpath = out_path,
            variable = var,
            cod = inv$station[inv$file_id==f],
            nam = inv$name[inv$file_id==f],
            lat = inv$lat[inv$file_id==f],
            lon = inv$lon[inv$file_id==f],
            alt = inv$ele[inv$file_id==f],
            sou = sou,
            link = link,
            units = unit,
            stat = stat,
            period = period,
            note = "monthly",
            keep_na = TRUE)
}

## Check SEF files

setwd(out_path)
for (f in list.files(pattern=".tsv")) {
  print(f)
  check_sef(f)
}

