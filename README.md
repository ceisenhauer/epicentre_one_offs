Covid in Herat <img src='www/logo.svg' align='right' alt='' width='200' />
====================================================================================================

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->



Context
----------------------------------------------------------------------------------------------------
This project aims to analyze data from the first four waves of the COVID-19 epidemic in Afghanistan, with a focus on the district of Herat. In this district, MSF has been running a triage unit since part way through the first wave. The analyses performed here hope to characterize the general progression of the epidemic and to evaluate if there are any important differences in the risk factors of severe disease observed in Afghanistan by comparison to other parts of the world.


Immediate TODOs
----------------------------------------------------------------------------------------------------

#### Main Analyses
- [x] clean new data for incorporation
    - [x] update cleaning rules as needed (see notes)
    - [x] separate out cleaning/validation into function
- [x] identify wave four ---> nov 11 2021 - end
- [x] sens / spec of case definition
    - [x] <b>table</b>
- [ ] descriptive
    - [x] <b>plot</b> cases + positivity (+ deaths?) x 2 (national + hrt)
    - [x] <b>plot</b> triage trends, overall
    - [x] <b>plot</b> triage trendds, severe (+ deaths?) 
    - [x] **plot** severity risk over time
    - [x] **table** overall outcomes by wave @nat @hrt
    - [x] **plot** boxplot delay by wave + overall
    - [x] **plot** delay med + iqr by time (week or month)
    - [x] **plot** delay by sex
    - [x] **table** pop description
    - [x] **tables** symp / risk factors / vitals etc across waves
    - [ ] **tables** symp / risk factors / vitals etc between severe and not
- [ ] regression
    - [x] univariate (logistic)
    - [x] multivariate logistic - ALL waves
        - [x] check if fits individually to each wave as well
        - [ ] fit with joint model for age-delay?
        - [ ] figure out a viz for interaction term
    - [ ] multivariate logistic - by wave allowing for different vars (maybe not needed...can be confusing...?)
    - [ ] sensitivity : model with unkowns for age and delay
    - [ ] sensitivity : overall model removing repeat visitors
    - [x] single model? waves as cat var --> doesn't work

#### Refactoring
- [x] consider modularizing
    - [x] **mod** load data (jhu, moph, msf)
    - [x] **fct** update data (moph, msf)
    - [x] independent regression file? --> nah
- [x] ggplot extra geoms
    - [x] date axis
    - [x] waves
    - [x] second axis
- [ ] make use of partials
    - [x] cut
    - [ ] quintiles
    - [x] sum, etc na.rm
    - [x] summarize drop groups


