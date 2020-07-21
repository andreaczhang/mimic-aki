# I already have the data, so now need to make it into a proper format 
library(magrittr)
library(purrr)
library(dplyr)


dataPathAKI <- '~/Documents/Data/MIMIC-AKI/'
aki_ts <- read.csv(paste0(dataPathAKI, 'cohortTS_akiAll.csv'))
aki_ch <- read.csv(paste0(dataPathAKI, 'cohortInfo_akiAll.csv'))


# ----- examine TS ----- #
aki_ts$subject_id %>% unique %>% length  # 3759 unique patients
aki_ts$icustay_id %>% unique %>% length  # 4739 unique icustays


colnames(aki_ts)
head(aki_ts)
# remove the first col
aki_ts2 <- select(aki_ts, -c('X'))







# ----- examine cohort ----- # 
# it basically only has the outcome, no demographics available

aki_ch$subject_id %>% unique %>% length  # 3759 unique patients
aki_ch$icustay_id %>% unique %>% length  # 4739 unique icustays
# same as ts




# ====== put TS into lists ====== #
# by the order of aki_ch
icustayIDs <- unique(aki_ch$icustay_id)

patientList <- function(allDF, unqIcustay){
  individualPatient <- list()
  for (i in 1:length(unqIcustay)){
    
    rowindex <- which(allDF$icustay_id == unqIcustay[i])
    individualPatient[[i]] <- allDF[rowindex, ]
  }
  names(individualPatient) <- paste0('icustay_', unqIcustay)
  return(individualPatient = individualPatient)
}

pList <- patientList(allDF = aki_ts2, unqIcustay = icustayIDs)
pList$icustay_200066

# saveRDS(pList, file = paste0('~/Documents/Data/MIMIC-AKI/cohortTS_list.RData'))



# get some basic information about the cohort, such as los, etc
# check the maximum hour from the list 
hr_max <- map_dbl(dlist, function(x){max(x$hr)})
hist(hr_max)
summary(hr_max)

