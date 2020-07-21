getSummStat_eachFeat <- function(featCol){
  # first check NA: if all NA, then impute with NAs
  nNA <- sum(is.na(featCol))
  if(nNA == length(featCol)){
    fmax <- NA
    fmin <- NA
    fmean <- NA
  }else{
    fmax <- max(featCol, na.rm = T)
    fmin <- min(featCol, na.rm = T)
    fmean <- mean(featCol, na.rm = T)
    
  }
  sumstat <- c(fmax = fmax, 
               fmin = fmin, 
               fmean = fmean)
  return(sumstat = sumstat)
}


getSummStat_eachPatient <- function(patientDF){
  # first rename 
  # it is a bit easier if I use 'starts_with' to select feature cols
  df_renamed <- rename(patientDF, 
                       id_subject = subject_id, 
                       id_hadm = hadm_id, 
                       id_icustay = icustay_id, 
                       id_hr = hr) 
  # only select features 
  df_feats <- select(df_renamed, -starts_with('id'))
  # get feature summary, then put into a vector
  summ_vec <- map(df_feats, getSummStat_eachFeat) %>% unlist
  return(summ_vec)
}

