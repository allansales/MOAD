library(readr)
library(data.table)
library(dplyr)
library(stringr)

########################## CONSTANTS ##########################

address <- "/local/datasets/"
size_sample = 1000

########################## FUNCTIONS ###########################

rewrite.lfm <- function(u){
  Iu = filter(LFM, userid == u)
  artists.line = as.list(t(Iu$artistid))
  fwrite(artists.line, 
          paste0(address,"experimento/LFM.byUser.txt"),
          row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE, append = TRUE)
}

########################## DATA READ ##########################


# This code is commented because it doesn't need to be reexecuted.
# LFM_1b_users <- read_delim("/local/datasets/LFM/LFM-1b_users.txt", 
#                            "\t", escape_double = FALSE, trim_ws = TRUE)
# user.sample.10k = LFM_1b_users[sample(nrow(LFM_1b_users), 10000),"user_id"]
# fwrite(user.sample.10k,
#        paste0(address, "LFM/sample10k.txt"),
#        row.names = FALSE, col.names = FALSE, quote = FALSE)

# Linux commands for selecting a subset of 10k users from LFM-1b dataset
# awk -F'\t' 'NR==FNR{check[$0];next} $1 in check' sample10k.txt LFM-1b_LEs.txt > LEs_sample10k.txt

LFM <- read_delim(paste0(address,"LFM/LEs_sample10k.txt"), 
                         "\t", escape_double = FALSE, col_names = FALSE, 
                         trim_ws = TRUE)

names(LFM) = c("userid", "artistid", "albumid", "trackid", "timestamp")


# LFM <- fread(paste0(address,"experimento/LFM.artists.available.txt"),
#              sep = "\t",
#              verbose = TRUE,
#              na.strings = "")
# LFM = as.data.frame(LFM)
# names(LFM) = c("artistid", "userid", "timestamp", "country", "age", "gender", "playcount", "registered", "artistname")
# LFM[,4:8] = NULL

# artist.data <- fread(paste0(address,"experimento/artist.data.txt"), 
#                      sep = ";", 
#                      verbose = TRUE,
#                      na.strings = "")
# artist.data = as.data.frame(artist.data)
# names(artist.data)[2] = c("artistname")

########################## USER'S HISTORY ##########################

# Ordering - UID - Timestamp
LFM = LFM[order(LFM$userid, LFM$timestamp),]

users = unique(LFM$userid)

ptm <- proc.time()
lapply(users,rewrite.lfm)
time.elapsed = proc.time() - ptm
time.elapsed
