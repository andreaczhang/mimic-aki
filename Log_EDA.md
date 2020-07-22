> Exploratory analysis of AKI summary stat dataset. 
>
> (using the techniques described in the **R for Data Science** book)

### Ask questions

First need to know what to do, not blindly do plots. Two types of questions: 

- variation occurs within each variable
- covariation occurs between each variable

As per `dlookr` workflow, the whole EDA can take 3 steps: 

1. **diagnose**
2. **explore** 
3. **Transformation** 

I think it is ok to combine the first two together. 



> ### <span style = 'color:tomato'>Diagnose and explore checklist</span>
>
> - Missing -> imputation
> - Distribution of each variable -> transformation
>   - including outliers
> - Correlation between variables -> collinearity
>
> Handy package: `dlookr`
>
> - `dlookr::describe()`
> - `dlookr::diagnose()`, can avoid doing the hand-coded unique and NA anymore 



## Explore variations

### visualise distributions

barplot vs histogram: I think barplot is histogram for discrete values. 



#### typical values 

- most frequent, rarest
- max, min

- clusters (bi/trimodal), and explore why they tend to cluster 



#### unusual values (outliers)

#### missing values (and imputation)



### covariations among variables

**scatter plot** (continuous vs continuous)

**boxplot** (discrete vs continuous). interquartile range (25 to 75%)

**Heat map** or **grid** (with different size for pairs of x-y) (discrete vs discrete)

Note that the type of data is not absolute, for example we can also use boxplot for continuous data. 



## Transformation 

Motivation to transform non-normal data: 

- approximate a distribution that has nicer theoretical properties, such as symmetry
- make the relationship between variables more linear 



### Missing

`dlookr::imputate_na()`

Numeric: mean, median, mode; KNN, rpart, MICE (multivariate imputation with chained equation)

Categorical: mode, rpart, MICE

MICE takes way too long!!! 

### Outliers 

`dlookr::imputate_outlier()`

Only support numeric: mean, median, mode, capping (5 and 95 percentile)



### Standardization

- zscore (same as scale). (x-mu)/sigma
- minmax. (x-min)/(max-min)



### Skewness

http://seismo.berkeley.edu/~kirchner/eps_120/Toolkits/Toolkit_03.pdf

`dlookr::find_skewness()` is handy 

- log
- log+1 (when there is 0)
- sqrt 
- 1/x
- x^2
- x^3

General rule: left skewed data (concentrate at higher, such as `beta(1, 5)`) use **higher power (>1)**, while right skewed data (exponential, gamma, waiting times) use **lower than log**. 

