# derive 24h max, min for the time series dataset
library(magrittr)
library(purrr)
library(dplyr)
source('./Utility/1-prepare.R')

dataPathAKI <- '~/Documents/Data/MIMIC-AKI/'
dlist <- readRDS(paste0(dataPathAKI, 'cohortTS_list.RData'))

dlist$icustay_200066 %>% colnames()

# if 24h max, mean, min: filter the 24h window first 
dlist24 <- map(dlist, function(x){filter(x, hr>=0 & hr <24)})




# --- use 200066 as an example ---- #
df1 <- dlist24$icustay_200066
# one feature
getSummStat_eachFeat(df1$heartrate)
# all features
getSummStat_eachPatient(dlist24$icustay_200066)


# produce the whole cohort 
reslist <- list()
for(i in 1:length(dlist24)){
  reslist[[i]] <- getSummStat_eachPatient(dlist24[[i]])
  cat('icustay', i, 'done\n')
}

names(reslist) <- names(dlist24)
# put into a df 

summDF <- do.call(rbind, reslist) %>% data.frame
glimpse(summDF)



# ======= it can be more convenient to put the outcome together ===== # 
aki_ch <- read.csv(paste0(dataPathAKI, 'cohortInfo_akiAll.csv'))

# check if the id matches 
aki_ch$icustay_id %>% head

ids_summDF <- rownames(summDF)
# substring('icustay_200066', first = 9)
ids_dbl_summDF <- substring(ids_summDF, first = 9) %>% as.double

all.equal(aki_ch$icustay_id, ids_dbl_summDF) # ok

# bind the outcome 
# aki_ch$death
summDF$death <- aki_ch$death

saveRDS(summDF, file = paste0(dataPathAKI, 'cohort24_mmm.RData'))




