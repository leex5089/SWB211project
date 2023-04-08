*=========================*
*SWB211 Project
*Joint Density Calculation
*=========================*
 
*MO state fips code 29
*KS state fips code 20
*b_6county
 

*import block level data 2020
/*Table 1:     Race
Universe:    Total population
Source code: P1
NHGIS code:  U7B
U7B001:      Total*/


import delimited "G:\My Drive\0.SWB\SWB211\census_data\nhgis0202_csv\nhgis0202_ds248_2020_block.csv",clear
tab state
gen b_population=u7b001 // block-level count of total population
rename gisjoin b_gisjoin // block-level unique identifier
keep  b_gisjoin year state county blkgrpa tracta b_population
save "G:\My Drive\0.SWB\SWB211\intermediate_data\KS_MO_block_population_2020.dta",replace
 

 
 
*
/*  Table 1:     Sex by Earnings in the Past 12 Months (in 2021 Inflation-Adjusted Dollars) for the Population 16 Years and Over with Earnings in the Past 12 Months
    Universe:    Population 16 years and over with earnings
    Source code: B20001
    NHGIS code:  AOR6
        AOR6E001:    Total
        AOR6E002:    Male
        AOR6E003:    Male: $1 to $2,499 or loss
        AOR6E004:    Male: $2,500 to $4,999
        AOR6E005:    Male: $5,000 to $7,499
        AOR6E006:    Male: $7,500 to $9,999
        AOR6E007:    Male: $10,000 to $12,499
        AOR6E008:    Male: $12,500 to $14,999
        AOR6E009:    Male: $15,000 to $17,499
        AOR6E010:    Male: $17,500 to $19,999
        AOR6E011:    Male: $20,000 to $22,499
        AOR6E012:    Male: $22,500 to $24,999
        AOR6E013:    Male: $25,000 to $29,999
        AOR6E014:    Male: $30,000 to $34,999
        AOR6E015:    Male: $35,000 to $39,999
        AOR6E016:    Male: $40,000 to $44,999
        AOR6E017:    Male: $45,000 to $49,999
        AOR6E018:    Male: $50,000 to $54,999
        AOR6E019:    Male: $55,000 to $64,999
        AOR6E020:    Male: $65,000 to $74,999
        AOR6E021:    Male: $75,000 to $99,999
        AOR6E022:    Male: $100,000 or more
        AOR6E023:    Female
        AOR6E024:    Female: $1 to $2,499 or loss
        AOR6E025:    Female: $2,500 to $4,999
        AOR6E026:    Female: $5,000 to $7,499
        AOR6E027:    Female: $7,500 to $9,999
        AOR6E028:    Female: $10,000 to $12,499
        AOR6E029:    Female: $12,500 to $14,999
        AOR6E030:    Female: $15,000 to $17,499
        AOR6E031:    Female: $17,500 to $19,999
        AOR6E032:    Female: $20,000 to $22,499
        AOR6E033:    Female: $22,500 to $24,999
        AOR6E034:    Female: $25,000 to $29,999
        AOR6E035:    Female: $30,000 to $34,999
        AOR6E036:    Female: $35,000 to $39,999
        AOR6E037:    Female: $40,000 to $44,999
        AOR6E038:    Female: $45,000 to $49,999
        AOR6E039:    Female: $50,000 to $54,999
        AOR6E040:    Female: $55,000 to $64,999
        AOR6E041:    Female: $65,000 to $74,999
        AOR6E042:    Female: $75,000 to $99,999
        AOR6E043:    Female: $100,000 or more
 */
import delimited "G:\My Drive\0.SWB\SWB211\census_data\nhgis0205_csv\nhgis0205_csv\nhgis0205_ds254_20215_blck_grp.csv",clear

 
egen pinc_lt_45k=rowtotal(aor6e003 aor6e004 aor6e005 aor6e006 aor6e007 aor6e008 aor6e009 aor6e010 aor6e011 aor6e012 aor6e013 aor6e014 aor6e015 aor6e016 aor6e024 aor6e025 aor6e026 aor6e027 aor6e028 aor6e029 aor6e030 aor6e031 aor6e032 aor6e033 aor6e034 aor6e035 aor6e036 aor6e037)
gen s_pinc_lt_45k=pinc_lt_45k/aor6e001
rename gisjoin bg_gisjoin
keep bg_gisjoin s_pinc_lt_45k
save "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_earning.dta",replace // save bg-level data on income and education
 
 
  
 
 
 
*import block-group level data 2020: education and income

/*   Table 11:    Educational Attainment for the Population 25 Years and Over
    Universe:    Population 25 years and over
    Source code: B15003
    NHGIS code:  AOP8
        AOP8E001:    Total
        AOP8E002:    No schooling completed
        AOP8E003:    Nursery school
        AOP8E004:    Kindergarten
        AOP8E005:    1st grade
        AOP8E006:    2nd grade
        AOP8E007:    3rd grade
        AOP8E008:    4th grade
        AOP8E009:    5th grade
        AOP8E010:    6th grade
        AOP8E011:    7th grade
        AOP8E012:    8th grade
        AOP8E013:    9th grade
        AOP8E014:    10th grade
        AOP8E015:    11th grade
        AOP8E016:    12th grade, no diploma
        AOP8E017:    Regular high school diploma
        AOP8E018:    GED or alternative credential
        AOP8E019:    Some college, less than 1 year
        AOP8E020:    Some college, 1 or more years, no degree
        AOP8E021:    Associate's degree
        AOP8E022:    Bachelor's degree
        AOP8E023:    Master's degree
        AOP8E024:    Professional school degree
        AOP8E025:    Doctorate degree
  

  
  Table 14:    Household Income in the Past 12 Months (in 2021 Inflation-Adjusted Dollars)
    Universe:    Households
    Source code: B19001
    NHGIS code:  AOQH
        AOQHE001:    Total
        AOQHE002:    Less than $10,000
        AOQHE003:    $10,000 to $14,999
        AOQHE004:    $15,000 to $19,999
        AOQHE005:    $20,000 to $24,999
        AOQHE006:    $25,000 to $29,999
        AOQHE007:    $30,000 to $34,999
        AOQHE008:    $35,000 to $39,999
        AOQHE009:    $40,000 to $44,999
        AOQHE010:    $45,000 to $49,999
        AOQHE011:    $50,000 to $59,999
        AOQHE012:    $60,000 to $74,999
        AOQHE013:    $75,000 to $99,999
        AOQHE014:    $100,000 to $124,999
        AOQHE015:    $125,000 to $149,999
        AOQHE016:    $150,000 to $199,999
        AOQHE017:    $200,000 or morev
 
    */
	
import delimited "G:\My Drive\0.SWB\SWB211\census_data\nhgis0197_csv\nhgis0197_ds254_20215_blck_grp.csv",clear
egen bg_educ_lt_bachelars=rowtotal(aop8e002 aop8e003 aop8e004 aop8e005 aop8e006 aop8e007 aop8e008 aop8e009 aop8e010 aop8e011 aop8e012 aop8e013 aop8e014 aop8e015 aop8e016 aop8e017 aop8e018 aop8e019 aop8e020 aop8e021) // create bg-level count of pop less than bachelars degree (Educational Attainment for the Population 25 Years and Over)
egen bg_inc_lt_45000=rowtotal(aoqhe002 aoqhe003 aoqhe004 aoqhe005 aoqhe006 aoqhe007 aoqhe008 aoqhe009) // create bg-level count of pop less than bachelars degree (Educational Attainment for the Population 25 Years and Over)
gen s_bg_educ_lt_bachelars=bg_educ_lt_bachelars/aop8e001 //share within bg
gen s_bg_inc_lt_45000=bg_inc_lt_45000/aoqhe001 //share within bg
gen tot_hh=aoqhe001
rename gisjoin bg_gisjoin
keep bg_gisjoin bg_educ_lt_bachelars bg_inc_lt_45000 s_bg_educ_lt_bachelars s_bg_inc_lt_45000 tot_hh
save "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_educ_inc.dta",replace // save bg-level data on income and education

*import block-group level data 2020: age 

/*Data Type (E):
    Estimates
 
        NAME_E:      Geographic Area Full Name
 
    Table 1:     Sex by Age
    Universe:    Total population
    Source code: B01001
    NHGIS code:  AONT
        AONTE001:    Total
        AONTE002:    Male
        AONTE003:    Male: Under 5 years
        AONTE004:    Male: 5 to 9 years
        AONTE005:    Male: 10 to 14 years
        AONTE006:    Male: 15 to 17 years
        AONTE007:    Male: 18 and 19 years
        AONTE008:    Male: 20 years
        AONTE009:    Male: 21 years
        AONTE010:    Male: 22 to 24 years
        AONTE011:    Male: 25 to 29 years
        AONTE012:    Male: 30 to 34 years
        AONTE013:    Male: 35 to 39 years
        AONTE014:    Male: 40 to 44 years
        AONTE015:    Male: 45 to 49 years
        AONTE016:    Male: 50 to 54 years
        AONTE017:    Male: 55 to 59 years
        AONTE018:    Male: 60 and 61 years
        AONTE019:    Male: 62 to 64 years
        AONTE020:    Male: 65 and 66 years
        AONTE021:    Male: 67 to 69 years
        AONTE022:    Male: 70 to 74 years
        AONTE023:    Male: 75 to 79 years
        AONTE024:    Male: 80 to 84 years
        AONTE025:    Male: 85 years and over
        AONTE026:    Female
        AONTE027:    Female: Under 5 years
        AONTE028:    Female: 5 to 9 years
        AONTE029:    Female: 10 to 14 years
        AONTE030:    Female: 15 to 17 years
        AONTE031:    Female: 18 and 19 years
        AONTE032:    Female: 20 years
        AONTE033:    Female: 21 years
        AONTE034:    Female: 22 to 24 years
        AONTE035:    Female: 25 to 29 years
        AONTE036:    Female: 30 to 34 years
        AONTE037:    Female: 35 to 39 years
        AONTE038:    Female: 40 to 44 years
        AONTE039:    Female: 45 to 49 years
        AONTE040:    Female: 50 to 54 years
        AONTE041:    Female: 55 to 59 years
        AONTE042:    Female: 60 and 61 years
        AONTE043:    Female: 62 to 64 years
        AONTE044:    Female: 65 and 66 years
        AONTE045:    Female: 67 to 69 years
        AONTE046:    Female: 70 to 74 years
        AONTE047:    Female: 75 to 79 years
        AONTE048:    Female: 80 to 84 years
        AONTE049:    Female: 85 years and over
    */
import delimited "G:\My Drive\0.SWB\SWB211\census_data\nhgis0203_csv\nhgis0203_ds254_20215_blck_grp.csv",clear
egen bg_age_gt18=rowtotal(aonte007 aonte008 aonte009 aonte010 aonte011 aonte012 aonte013 aonte014 aonte015 aonte016 aonte017 aonte018 aonte019 aonte020 aonte021 aonte022 aonte023 aonte024 aonte025 aonte031 aonte032 aonte033 aonte034 aonte035 aonte036 aonte037 aonte038 aonte039 aonte040 aonte041 aonte042 aonte043 aonte044 aonte045 aonte046 aonte047 aonte048 aonte049) // create bg-level count of pop over age 18.
gen s_bg_age_gt18=bg_age_gt18/aonte001
rename gisjoin bg_gisjoin
keep bg_gisjoin bg_age_gt18 s_bg_age_gt18
save "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_age.dta",replace // save bg-level data on age


*---------------------------------------------------*
*merge B and BG level data, calculate target_density 
*---------------------------------------------------*

use "G:\My Drive\0.SWB\SWB211\intermediate_data\KS_MO_block_population_2020.dta",clear // open block data
merge 1:1 b_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\b_KC_6counties.dta" // merge to restrict area to 6 counties in KC
keep if _merge==3
drop _merge
merge 1:1 b_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\b_bg_county_crosswalk.dta" // block block-group county crosswalk file
keep if _merge==3
drop _merge
merge m:1 bg_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_age.dta" // add bg-level age
keep if _merge==3
drop _merge
merge m:1 bg_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_educ_inc.dta" // add bg-level educ and income 
keep if _merge==3
drop _merge 
merge m:1 bg_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_earning.dta" // add bg-level earning
keep if _merge==3
drop _merge 
 

gen s_joint_age_educ_inc=  s_bg_age_gt18 *s_bg_educ_lt_bachelars* s_pinc_lt_45k // joint probability age*educ*income of target population.
 
gen b_target_pop=b_population * s_joint_age_educ_inc // block-level count of target population.
replace b_target_pop=0 if b_target_pop==. 
egen tt=total( b_target_pop)
sum tt // total number of target population in the 6 counties is 304,982. The total number of population in 6 counties is  1,964,222. 
gen target_density=b_target_pop/tt // this is the probability density of target population. we can use this density info to generate points (that represents target population) over the space in 6 KC area. In 6 counties, the probaility of block sum up to 1.  
gen target_pop_per_sq_mile=b_target_pop/(shape_area/2589973.632302) // target population per sq mile

keep  shape_area fid county bg_gisjoin b_gisjoin b_population bg_age_gt18 bg_educ_lt_bachelars bg_inc_lt_45000   s_bg_age_gt18 s_bg_educ_lt_bachelars s_bg_inc_lt_45000 s_pinc_lt_45k s_joint_age_educ_inc b_target_pop target_pop_per_sq_mile target_density
order fid county bg_gisjoin b_gisjoin b_population bg_age_gt18 bg_educ_lt_bachelars bg_inc_lt_45000   s_bg_age_gt18 s_bg_educ_lt_bachelars s_bg_inc_lt_45000 s_joint_age_educ_inc b_target_pop  target_pop_per_sq_mile target_density
drop if county=="Miami County"
export delimited using  "G:\My Drive\0.SWB\SWB211\intermediate_data\block_level_target_population.csv", replace
 
*Produce descriptives
import delimited "G:\My Drive\0.SWB\SWB211\intermediate_data\block_level_target_population.csv",clear 
   
estpost sum b_population bg_age_gt18 bg_educ_lt_bachelars bg_inc_lt_45000 s_bg_age_gt18 s_bg_educ_lt_bachelars s_bg_inc_lt_45000 s_pinc_lt_45k  s_joint_age_educ_inc b_target_pop target_pop_per_sq_mile target_density   
esttab, cells("count mean sd min max")

sum s_bg_educ_lt_bachelars 

gen z_s_bg_educ_lt_bachelars=(s_bg_educ_lt_bachelars-`r(mean)')/`r(sd)'

sum s_bg_inc_lt_45000

gen z_s_bg_inc_lt_45000=(s_bg_inc_lt_45000-`r(mean)')/`r(sd)'

reg s_bg_educ_lt_bachelars s_bg_inc_lt_45000,robust
predict new,xb

reg z_s_bg_educ_lt_bachelars z_s_bg_inc_lt_45000,robust
predict new3,xb


gen gap=s_bg_educ_lt_bachelars-s_bg_inc_lt_45000






**************CHECK HOUSEHOLD SIZE

import delimited "G:\My Drive\0.SWB\SWB211\census_data\nhgis0204_csv\nhgis0204_ds254_20215_blck_grp.csv",clear
rename gisjoin bg_gisjoin 
keep bg_gisjoin aopte*
save "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_household_size.dta",replace






use "G:\My Drive\0.SWB\SWB211\intermediate_data\KS_MO_block_population_2020.dta",clear // open block data
merge 1:1 b_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\b_KC_6counties.dta" // merge to restrict area to 6 counties in KC
keep if _merge==3
drop _merge
merge 1:1 b_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\b_bg_county_crosswalk.dta" // block block-group county crosswalk file
keep if _merge==3
drop _merge
merge m:1 bg_gisjoin using "G:\My Drive\0.SWB\SWB211\intermediate_data\bg_household_size.dta"  
keep if _merge==3
drop _merge




gen tot_hh=aopte001
gen tot_fhh=aopte002
gen fhh_2person=aopte003
gen fhh_3person=aopte004
gen fhh_4person=aopte005
gen fhh_5person=aopte006
gen fhh_6person=aopte007
gen fhh_7person=aopte008 
gen fhh_1person=aopte002-(aopte003+aopte004+aopte005+aopte006+aopte007+aopte008)


gen tot_nfhh=aopte009
gen nfhh_1person=aopte010
gen nfhh_2person=aopte011
gen nfhh_3person=aopte012
gen nfhh_4person=aopte013
gen nfhh_5person=aopte014
gen nfhh_6person=aopte015
gen nfhh_7person=aopte016


foreach v in tot_hh tot_fhh fhh_2person fhh_3person fhh_4person fhh_5person fhh_6person fhh_7person fhh_1person tot_nfhh nfhh_1person nfhh_2person nfhh_3person nfhh_4person nfhh_5person nfhh_6person nfhh_7person{
	egen t_`v'=total(`v')
	
}


egen r_t_hh_1person=rowtotal(t_fhh_1person t_nfhh_1person)
egen r_t_hh_2person=rowtotal(t_fhh_2person t_nfhh_2person)
egen r_t_hh_3person=rowtotal(t_fhh_3person t_nfhh_3person)
egen r_t_hh_4person=rowtotal(t_fhh_4person t_nfhh_4person)
egen r_t_hh_5person=rowtotal(t_fhh_5person t_nfhh_5person)
egen r_t_hh_6person=rowtotal(t_fhh_6person t_nfhh_6person)
egen r_t_hh_7person=rowtotal(t_fhh_7person t_nfhh_7person)

foreach v in r_t_hh_1person r_t_hh_2person r_t_hh_3person r_t_hh_4person r_t_hh_5person r_t_hh_6person r_t_hh_7person{
	
	gen s_`v'=`v'/t_tot_hh
}

50%

s_r_t_hh_1person s_r_t_hh_2person






 s_r_t_hh_3person s_r_t_hh_4person s_r_t_hh_5person s_r_t_hh_6person s_r_t_hh_7person
