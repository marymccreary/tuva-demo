{{ config(
    materialized = "table"
  ) 
}}

SELECT op.person_id
     , p.sex
     , p.race
     , p.address_state
     , p.age_group
     , op.icd_10_cm
     , op.cancer_type
     , op.recorded_date
     , mc.medical_claim_id
     , mc.claim_id
     , mc.encounter_id
     , mc.member_id
     , mc.service_category_1
     , mc.service_category_2
     , mc.service_category_3
     , mc.claim_start_date
     , mc.claim_end_date
     , mc.paid_amount_cents
     , mc.allowed_amount_cents
     , mc.charge_amount_cents
FROM {{ ref('stg_core__medical_claims') }} mc
  INNER JOIN {{ ref('int_oncology_patients') }} op 
    ON mc.person_id = op.person_id
  INNER JOIN {{ ref('stg_core__patients') }} p
    ON mc.person_id = p.person_id
WHERE mc.claim_start_date >= op.recorded_date -- only include claims after cancer diagnosis date