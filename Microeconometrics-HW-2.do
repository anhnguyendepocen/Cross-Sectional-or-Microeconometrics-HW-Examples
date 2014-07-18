******** ECON 873 *****************************************************************
******** Spring 2014 **************************************************************
******** Robert Ackerman **********************************************************
**** HW2: Cameron and Trivedi, Microeconometrics: Methods and Applications ****

********* 1. Initial Settings *********
clear
clear matrix
capture cd "/Users/robertackerman/Desktop/Dropbox/Microeconometrics/"
log using "HW2_Ackerman.log", replace

set more off
pause on 

******** 2. Load the Entire Sample ********

infile mode price crate dbeach dpier dprivate dcharter pbeach ppier pprivate pcharter qbeach qpier qprivate qcharter income using NLDATA.ASC

******** 3. Generate 50% Subsample ********

** Fix Seed, so  the Same Subsample is Drawn Each Time **
set seed 123456789

** 50% Randomly Generated Subsample **
sample 50
su dbeach
su dpier
su dprivate
su dcharter
 
******** 4. Data Magagement, Note: This is based heavily on Cameron and Trivedi's mma15p2gev.do file ******** 

** Re-scale income by 1000 **
gen inc = income/1000

** Data are one entry per individual **
** Reshape to 4 observations per individual; one for each alternative **
** Use reshape to do this **
** Note:  alternatv = 1 if beach, = 2 if pier; = 3 if private boat; = 4 if charter **

** First generate new variables **
gen id = _n
gen d1 = dbeach
gen p1 = pbeach
gen q1 = qbeach
gen d2 = dpier
gen p2 = ppier
gen q2 = qpier
gen d3 = dprivate
gen p3 = pprivate
gen q3 = qprivate
gen d4 = dcharter
gen p4 = pcharter
gen q4 = qcharter

** Now use the reshape command ** 
reshape long d p q, i(id) j(alterntv)
** This automatically generates variable alterntv = 1 (beach), 2 (pier), 3 (boat) and 4 (charter) **

******** 5. 15-2 ********

** (a) Estimate the conditional logit model of Section 15.2.1. **
asclogit d p q, case(id) alternatives(alterntv) casevars(inc)

** (c) What is the effect of an increase in price on the various modes of fishing? ** 
estat mfx, varlist(p)

******** 6. 15-3 ********
clear

** Re-load the data, re-scale income and generate the subsample**
infile mode price crate dbeach dpier dprivate dcharter pbeach ppier pprivate pcharter qbeach qpier qprivate qcharter income using NLDATA.ASC
gen inc = income/1000
set seed 123456789
sample 50

** (a) Estimate the multinomial logit model of Section 15.2.2. **
mlogit mode inc, b(1)

** (b) Comment on the statistical significance of the parameter estimates. **
test inc

** (c) What is the effect of an increase in income on the various modes of fishing? ** 
margins, dydx(inc) predict(outcome(1)) atmean
margins, dydx(inc) predict(outcome(2)) atmean
margins, dydx(inc) predict(outcome(3)) atmean
margins, dydx(inc) predict(outcome(4)) atmean


******** 7. 15-4 ********
** Collapse the data into a three alternative model **
replace mode=0 if mode==1 | mode==2
replace mode=1 if mode==3
replace mode=2 if mode==4

** (a) Estimate an ordered logit model with income as the only regressor. **
ologit mode inc

** (b) Provide an interpretation of the estimated coefficient **

** (c) Compare the fit of this model with that from a three-choice multinomial model with income as the regressor **
mlogit mode inc, b(1)

clear

log close
