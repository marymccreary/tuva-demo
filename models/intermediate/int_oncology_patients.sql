{{ config(
    materialized = "table"
  ) 
}}

WITH oncology_patients AS (

-- limiting to most recent recorded cancer condition per patient
SELECT c.person_id
     , c.icd_10_cm
     , icd10.cancer_type
     , c.recorded_date
     , row_number() OVER (PARTITION BY c.person_id ORDER BY c.recorded_date DESC) AS rn
FROM {{ ref('stg_core__conditions') }} c
  INNER JOIN {{ ref('icd-10-cancer-codes') }} icd10
    ON c.icd_10_cm = icd10.icd10_code
  INNER JOIN {{ ref('stg_core__patients') }} p
    ON c.person_id = p.person_id
WHERE c.condition_status = 'active'
  AND p.is_deceased = false
-- could do this with a qualifies statement, but not all sql dialects support it

)

SELECT person_id
     , icd_10_cm
     , cancer_type
     , recorded_date
FROM oncology_patients
WHERE rn = 1