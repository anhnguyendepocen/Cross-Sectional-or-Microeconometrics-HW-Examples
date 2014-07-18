**** ECON 873 ************************************************************************************
**** Spring 2014 *********************************************************************************
**** Robert Ackerman *****************************************************************************
**** HW7 *****************************************************************************************
**** Cameron and Trivedi Microeconometrics Exercise 20-4 *****************************************
**** Note The Following Benefits Heavily from mimicking CT's mma19p1comprisks.do **************

**** Initial Settings ****
clear
clear matrix
capture cd "/Users/robertackerman/Desktop/Dropbox/Microeconometrics"
log using "HW6_Ackerman.log", replace

set more off
pause on 

**** Load Data ****
* use "/Users/robertackerman/Desktop/Dropbox/Econ 873/mma10252005/ema1996.dta", clear

infile lnhr lnwg kids ageh agesq disab id year using "/Users/robertackerman/Desktop/Dropbox/Microeconometrics/MOM.dat"

** Fix Seed, so  the Same Subsample is Drawn Each Time **
set seed 123456789

** 50% Randomly Generated Subsample **
sample 50

**** (b) (1) Pooled OLS ****

* POLS, beta and default SE
reg lnhr lnwg

* BS SE
set seed 123456789
bs "reg lnhr lnwg" "_b[lnwg] _b[_cons]", cluster(id) reps(200)

**** (b) (2) Between ****

* Between, beta and default SE
xtreg lnhr lnwg, be i(id)

* BS SE
set seed 123456789
bs "xtreg lnhr lnwg, be i(id)" "_b[lnwg] _b[_cons]", cluster(id) reps(200) 

**** (b) (3) Within ****

* Within, beta and default SE
xtreg lnhr lnwg, fe i(id)
est store feiid

* BS SE
set seed 123456789
bs "xtreg lnhr lnwg, fe i(id)" "_b[lnwg] _b[_cons]", cluster(id) reps(200)


**** (b) (4) FD ****
sort id year
gen dlnhr = lnhr - lnhr[_n-1]
gen dlnwg = lnwg - lnwg[_n-1]
drop if year == 1979

* FD, beta and default SE
reg dlnhr dlnwg

* BS SE
set seed 123456789
bs "reg dlnhr dlnwg" "_b[dlnwg]", cluster(id) reps(200)

**** (b) (5) RE GLS ****

**** Need to Re-Load Data ****
clear
infile lnhr lnwg kids ageh agesq disab id year using "/Users/robertackerman/Desktop/Dropbox/Microeconometrics/MOM.dat"

** Fix Seed, so  the Same Subsample is Drawn Each Time **
set seed 123456789

** 50% Randomly Generated Subsample **
sample 50

* RE GLS, beta and default SE
xtreg lnhr lnwg, re i(id)
est store reiid

* BS SE
set seed 123456789
bs "xtreg lnhr lnwg, re i(id)" "_b[lnwg] _b[_cons]", cluster(id) reps(200)

**** (b) (6) RE MLE ****
* RE MLE, beta and default SE
xtreg lnhr lnwg, mle i(id)

* BS SE
set seed 123456789
bs "xtreg lnhr lnwg, mle i(id)" "_b[lnwg] _b[_cons]", cluster(id) reps(200)

**** (f) ****
hausman feiid reiid

log close
