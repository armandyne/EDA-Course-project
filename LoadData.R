if (!file.exists("./data")) {
     dir.create("./data")
}

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipfile <- file.path("./data", "NEI_data.zip")

if (!file.exists(zipfile)) {
     download.file(url, zipfile)
}

if (length(list.files(path="./data", pattern = "\\.rds$"))==0) {
     unzip(zipfile, exdir = "./data")
}
