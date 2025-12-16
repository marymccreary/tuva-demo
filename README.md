## 🤝 Mary's Take Home Project

Staging tables

Created staging tables off of the source tables
core.condition 
core.patient
core.medical_claims

In the staging tables we pull in only the populated columns from the source tables
Columns are cast to their respective data types
Renamed for consistency 
   - timestamps end in "_at"
   - booleans begin with "_is" or "_has"
   - columns like 'status' which are reserved words in sql are converted to names like 'condition_status'
   - columns for internal purposes start with an underscore 
   - columns orderd by: ids, booleans, varchars, ints/numbers, dates, timestamps
Add additional columns for reporting ease of use ( for example, adding a specific column for the icd-10 code to avoid having to check for the code type each time)


Intermediate

Here I'm doing a simple search for patients who are alive who have an active condition where the icd code matches a list of cancer icd codes.  

In a real reporting environment, I might not just search their condition list, but also search for encounter and claim codes, as physicians may not always be diligent about keeping the problem list up to date. Additionally, you might add a time contraint, like conditions added in the last three years or so. 

For simplicity (aka test time restriction), patients who may have multiple cancers are being limited to their most recently recorded cancer for the purposes of this test. 

Mart

This mart, oncology_patient_claims, brings together patient demographic information with their claims info, so that we can find out more about who is racking in the highest costs. 

This mart is inelegant! I acknowledge that, but wanted to stick to the time limit
Right now the mart is just pulling any claims for cancer patients after the cancer digagnosis was added to their conditions. 
Obviously this isn't quite correct, as there can be encounters not realted to their cancer among those, like if they were to break their arm. 
A better way to do this would have been to find claims on encounters where the encounter had a cancer diagnosis attached.


## Findings

Of all the money paid for active cancer patient claims:
83% of the total was spent on prostate cancer patients
39% of the total was spent on prostate cancer patients in the 70-79 age range

Cost is divided between patient sex, 57% male and 43% female

36% of costs were incurred in an outpatient setting, while 29% were inpatient 


Slicing and dicing of numbers was calculated with a query like so: 

SELECT
    service_category_1,
    SUM(paid_amount_cents) AS total_paid,
    ROUND( SUM(paid_amount_cents) / SUM(SUM(paid_amount_cents)) OVER () * 100, 2) AS percent_of_total_paid
FROM oncology_patient_claims
GROUP BY 1
ORDER BY percent_of_total_paid DESC

## AI Usage 

Pulled ICD 10 codes from https://www.cancertherapyadvisor.com/home/tools/oncology-icd10-codes/, and asked chat gpt to create a csv to categorize the icd-10 codes into cancer types based on simple organ based groupings 

Used github copilot suggestions as they came up (autocomplete joins, select statements, etc)

Used chatGPT to generate a query to calculate the percent_of_total_paid queries used in the findings 

## What more I could have done

This is currently super inelegant way to finding oncology claims, as I'm just finding every claim from oncology patients after their condition is recorded, instead of finding claims actually related to the cancer care. 

Also, the tuva data marts seem like they might have had better ways of checking if a patient had multiple types of cancer, so exploring those pre-made marts is another thing I would have liked to spend more time on

Also, I could do so much more documentation! There should be yml for all the models, the columns, and tests to make sure there are primary keys that are non null and unique. 

There were lots of fields that didn't seem to be populated - I'd want to go in and check why that data isn't flowing in and what can be done about it. 