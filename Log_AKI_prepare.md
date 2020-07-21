> Notes for preparing the AKI cohort (TS only). 
>
> The purpose for this side project is to improve my skills for classification, using `caret` and `tidymodel` workflows. It is always good to have one dataset that is ready, and that I know very well; that is how AKI cohort comes into play. The only disadvantage for using AKI, or any MIMIC cohort is that the dataset can not be directly used by any user - they have to download the data on their own. 

### Basic information about this dataset

I use `icustay` as unit, not `patient_ID`. The cohort has 4739 unique icu stays. 

In the time series record, the maximum hour for each icu stay has mean 136hr, median 70h.

The dataset I am using does NOT have demographic information. (that would require a bit more work to extract from the DB)



### Derive into max_min_mean_24h

The new dataset is the one we can use for fun. 



