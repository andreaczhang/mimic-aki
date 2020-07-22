# do some exploratory analysis, and process 
library(magrittr)
library(purrr)
library(dplyr)
library(dlookr) # data diagnosis, transformation 

 
dataPathAKI <- '~/Documents/Data/MIMIC-AKI/'
daki <- readRDS(file = paste0(dataPathAKI, 'cohort24_mmm.RData'))
# also take features only, remove the outcome 
dakifeats <- select(daki, -c('death'))

daki %>% glimpse
summary(daki)





# ------ 1. NA, outliers (describe and diagnose) ------ # 
percent_na <- apply(dakifeats, 2, function(x){(sum(is.na(x)))/nrow(dakifeats)})
percent_na %>% barplot


table_described <- describe(dakifeats)
# it is not that meaningful to worry about the kurtosis here 

table_described$skewness %>% which.min  # negative skewness
dakifeats[19] %>% hist

table_described$skewness %>% which.max  # positive skewness
dakifeats[152] %>% hist


table_diagnosed <- diagnose(dakifeats)
# using diagnose, do not need to hand-code missing percent, unique count anymore 
table_diagnosed %>% arrange(desc(missing_percent))
table_diagnosed %>% arrange(missing_percent)

# diagnose with specific type 
# will also give outliers
table_diagnosed_num <- diagnose_numeric(dakifeats)

table_diagnosed_out <- diagnose_outlier(dakifeats)
# outliers ratio: percent of outliers
# always need to pay attend to high ratio outliers 
# can plot 
plot_outlier(dakifeats, heartrate.fmean)
plot_outlier(dakifeats, gcs.fmean)  
# in this extreme case, the data is very left skewed
# though I don't think it's reasonable to remove them, it is totally 
# realistic for patients to have many small gcs.




# ------ 2. distribution ------- # 
# this includes outliers 
# focus on the mean here 

fmeans <- select(dakifeats, ends_with('fmean'))

boxplot(fmeans, ylim = c(0, 200))
# it is obvious there is one feature with strange values 
# also, it doesn't make too much sense to plot all of them together
# because of units, the nature of the features.

# can check normality 
normality(fmeans) %>% arrange(desc(p_value))

plot_normality(fmeans, heartrate.fmean)



# ------ 3. correlation -------- # 
# this is more convenient than corrplot, do not need to remove NA by hand
plot_correlate(fmeans)





# =========== transformation =========== # 
# ------ 1. missing imputation ------ #
# including missing values, outliers, skewness etc
# use fmean subset

table_dianosed_fmean <- diagnose(fmeans)

# start with sysbp, which has 6.67% missing 
sysbp <- fmeans$sysbp.fmean

sysbp_knn <- imputate_na(fmeans, sysbp.fmean, method = 'knn')
sysbp_mean <- imputate_na(fmeans, sysbp.fmean, method = 'mean')
sysbp_median <- imputate_na(fmeans, sysbp.fmean, method = 'median')

# sysbp_mice <- imputate_na(fmeans, sysbp.fmean, method = 'mice')  
# this is way too complicated

summary(sysbp_mean) 
summary(sysbp_knn)
summary(sysbp_mice)
# plot the imputed
# probably need to use the median for imputation
plot(sysbp_mean)
plot(sysbp_median)
plot(sysbp_knn)
plot(sysbp_mice)
# I'm not sure it is really worth it

# doesn't look like I can impute altogether, need to do one by one
imputate_na(fmeans, 'sysbp.fmean',  method = 'median')

imputed_fmeans <- map(names(fmeans), function(x){imputate_na(fmeans, x, method = 'median')}) %>% 
  do.call(cbind, .) %>% data.frame
colnames(imputed_fmeans) <- names(fmeans)

#### save the data and outcome! 
# dataPathAKI <- '~/Documents/Data/MIMIC-AKI/'
# daki_impute <- imputed_fmeans
# daki_impute$death <- daki$death
# saveRDS(daki_impute, file = paste0(dataPathAKI, 'cohort24_mmm_imputed.RData'))




# ------ 2. outlier ------- #
# I think it is not really good to impute outliers 
# it should be ok to transform using log or minmax. 
table_dianosed_fmean_out <- diagnose_outlier(fmeans)
# use spo2, which has 3.2% outliers 

spo2_impout <- imputate_outlier(fmeans, spo2.fmean, method = 'capping')
plot(spo2_impout)
hist(fmeans$spo2.fmean, breaks = 40)
hist(spo2_impout, breaks = 40)

summary(spo2_impout)




# 3. standardization and skewness 
# probably need to impute missing values first 
find_skewness(imputed_fmeans, value = T)

# experiment with the ladder of powers for left and  right skewed data
leftskew <- imputed_fmeans$gcsmotor.fmean
rightskew <- imputed_fmeans$pt.fmean


# leftskew (clustered at higher end)
# for very heavily skewed data, only very high power could work
hist(leftskew)
hist(log(leftskew))
hist(leftskew^1)
hist(leftskew^0.5)
hist(leftskew^(-0.5))
hist(leftskew^(0))


sim_leftskew <- rbeta(1000, 5, 1)
hist(sim_leftskew^3)  # ok 
hist(sim_leftskew^2)
hist(sim_leftskew^1)  # original 
hist(sim_leftskew^0.5)
hist(log(sim_leftskew))




# right skew (clustered at lower end)
hist(rightskew)
hist(rightskew^2)  # this completely shrink everything to the left end
hist(log(rightskew))  # better
hist(rightskew^-0.5)  
hist(rightskew^-1)   # this also looks decent 











