clear
clear matrix
capture cd "/Users/robertackerman/Desktop/Dropbox/Microeconometrics/"
log using "HW1_Ackerman.log", replace

use "/Users/robertackerman/Desktop/Dropbox/Microeconometrics/randdata.dta"
set more off
pause on 

** Re-name variables (from CT do file) **
rename meddol MED
rename binexp DMED
rename lnmeddol LNMED
rename linc LINC
rename lfam LFAM
rename educdec EDUCDEC
rename xage AGE
rename female FEMALE
rename child CHILD 
rename fchild FEMCHILD
rename black BLACK
rename disea NDISEASE
rename physlm PHYSLIM
rename hlthg HLTHG
rename hlthf HLTHF
rename hlthp HLTHP
rename idp IDP
rename logc LC
rename lpi LPI
rename fmde FMDE

** Part 14-5 (a) OLS **
reg DMED NDISEASE
predict pols, xb
margins, dydx(NDISEASE)
** Parts 14-5 (b-c) Probit **
probit DMED NDISEASE
predict pprobit, pr
margins, dydx(NDISEASE)
margins, dydx(NDISEASE) atmean

** Parts 14-5 (d-f) Logit **
logit DMED NDISEASE
predict plogit, pr
margins, dydx(NDISEASE)
margins, dydx(NDISEASE) atmean 

** Predicted Probabilities Plot **
sort NDISEASE
twoway (scatter DMED NDISEASE) (line pols NDISEASE) (line pprobit NDISEASE) (line plogit NDISEASE)
log close
