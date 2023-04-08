#!/usr/bin/env python
# coding: utf-8

# #  SWB211 Project 
# 
# ## Joint Density Calculation
# 
# 

# ### Setting

# In[151]:


import pandas as pd ## import pandas module for data manipulation, just 2017 and 2018 test data for this exercise.
import os
os.chdir(r"G:\My Drive\0.SWB\SWB211")  # Provide the new path here
print(os.getcwd()) # Prints the current working directory
 


# ### prepare block-level data

# In[152]:



block_raw = pd.read_csv(r"census_data\nhgis0202_csv\nhgis0202_ds248_2020_block.csv") #insert the path directory of the file you want to import 
block_raw.columns = block_raw.columns.str.lower()

block_data=block_raw[['gisjoin', 'state','county','u7b001']]
block_data = block_data.rename(columns={'gisjoin': 'b_gisjoin'})                
block_data = block_data.rename(columns={'u7b001': 'b_population'}) # b_target_pop: Block level count of total population.                
                     


# ### prepare block-group-level data (education, Income data)

# In[153]:



blockgroup_raw = pd.read_csv(r"census_data\nhgis0197_csv\nhgis0197_ds254_20215_blck_grp.csv") #insert the path directory of the file you want to import 
blockgroup_raw.columns = blockgroup_raw.columns.str.lower()
col_list=blockgroup_raw[['aop8e002', 'aop8e003', 'aop8e004', 'aop8e005', 'aop8e006', 'aop8e007', 'aop8e008' ,'aop8e009', 'aop8e010', 'aop8e011', 'aop8e012', 'aop8e013', 'aop8e014', 'aop8e015', 'aop8e016', 'aop8e017', 'aop8e018', 'aop8e019', 'aop8e020', 'aop8e021']]
blockgroup_raw['bg_educ_lt_bachelars']=col_list.sum(axis=1)
col_list=blockgroup_raw[['aoqhe002', 'aoqhe003', 'aoqhe004', 'aoqhe005', 'aoqhe006', 'aoqhe007', 'aoqhe008', 'aoqhe009']]
blockgroup_raw['bg_inc_lt_45000']=col_list.sum(axis=1)

blockgroup_raw['s_bg_educ_lt_bachelars']=blockgroup_raw['bg_educ_lt_bachelars']/blockgroup_raw['aop8e001']
blockgroup_raw['s_bg_inc_lt_45000']=blockgroup_raw['bg_inc_lt_45000']/blockgroup_raw['aoqhe001']
blockgroup_raw = blockgroup_raw.rename(columns={'gisjoin': 'bg_gisjoin'})                
bg_educ_inc=blockgroup_raw[['bg_gisjoin', 'bg_educ_lt_bachelars','bg_inc_lt_45000','s_bg_educ_lt_bachelars','s_bg_inc_lt_45000']]


# ### prepare block-group-level data (age data)

# In[154]:


blockgroup_raw = pd.read_csv(r"census_data\nhgis0203_csv\nhgis0203_ds254_20215_blck_grp.csv") #insert the path directory of the file you want to import 
blockgroup_raw.columns = blockgroup_raw.columns.str.lower()
blockgroup_raw.describe()
print(blockgroup_raw.info())
blockgroup_raw.describe()
blockgroup_raw.dtypes 
col_list=blockgroup_raw[['aonte007', 'aonte008', 'aonte009', 'aonte010', 'aonte011', 'aonte012', 'aonte013', 'aonte014', 'aonte015', 'aonte016' ,'aonte017', 'aonte018', 'aonte019' ,'aonte020', 'aonte021', 'aonte022', 'aonte023' ,'aonte024' ,'aonte025' ,'aonte031' ,'aonte032', 'aonte033', 'aonte034' ,'aonte035', 'aonte036', 'aonte037', 'aonte038', 'aonte039', 'aonte040', 'aonte041', 'aonte042', 'aonte043', 'aonte044', 'aonte045', 'aonte046', 'aonte047', 'aonte048', 'aonte049']]
blockgroup_raw['bg_age_gt18']=col_list.sum(axis=1)
blockgroup_raw['s_bg_age_gt18']=blockgroup_raw['bg_age_gt18']/blockgroup_raw['aonte001']
blockgroup_raw = blockgroup_raw.rename(columns={'gisjoin': 'bg_gisjoin'})                
bg_age=blockgroup_raw[['bg_gisjoin', 'bg_age_gt18','s_bg_age_gt18' ]]


# ### prepare cross-walk data 

# In[155]:


##b_KC_6counties
b_KC_6counties = pd.read_stata(r"intermediate_data\b_KC_6counties.dta") #// merge to restrict area to 6 counties in KC
b_KC_6counties.columns = b_KC_6counties.columns.str.lower()
##JOIN
b_bg_county_crosswalk = pd.read_stata(r"intermediate_data\b_bg_county_crosswalk.dta") # block block-group county crosswalk file   
b_bg_county_crosswalk.columns = b_bg_county_crosswalk.columns.str.lower()


# ### Merge block and block-group data to calculate joint density of target pop

# In[156]:


#merge B and BG level data, calculate target_density 
merge1=pd.merge(block_data, b_KC_6counties,on=['b_gisjoin' ])  # merge to restrict area to 6 counties in KC (426161 to 37701)
merge2=pd.merge(merge1, b_bg_county_crosswalk,on=['b_gisjoin' ])  # block block-group county crosswalk file
merge3=pd.merge(merge2, bg_age,on=['bg_gisjoin' ])  # add bg-level age
merge4=pd.merge(merge3, bg_educ_inc,on=['bg_gisjoin' ])  # add bg-level bg_educ_inc


merge4['s_joint_age_educ_inc']=merge4['s_bg_age_gt18']*merge4['s_bg_educ_lt_bachelars']*merge4['s_bg_inc_lt_45000'] # joint probability age*educ*income of target population.
merge4['b_target_pop']=merge4['b_population']*merge4['s_joint_age_educ_inc']  # block-level count of target population.
merge4['total_target_pop']=merge4['b_population'].sum()  # block-level count of target population.
merge4 = merge4.fillna(0)

merge4['target_density']=merge4['b_target_pop']//merge4['total_target_pop']
merge4['target_pop_per_sq_mile']=merge4['b_target_pop']// merge4['shape_area_x'] //2589973.632302 
 


# In[157]:


merge4.info()


# ### save final output file

# In[158]:


final_block_data=merge4[[  'fid', 'county' ,'bg_gisjoin' ,'b_gisjoin' ,'b_population', 'bg_age_gt18', 'bg_educ_lt_bachelars', 'bg_inc_lt_45000','s_bg_age_gt18', 's_bg_educ_lt_bachelars', 's_bg_inc_lt_45000', 's_joint_age_educ_inc' ,'b_target_pop', 'target_pop_per_sq_mile', 'target_density']]
final_block_data.to_excel("intermediate_data/block_level_target_population_outofpython.xlsx",index=False)   ##export the final final_block_data file.


# In[ ]:




