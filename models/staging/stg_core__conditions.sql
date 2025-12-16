{{ config(
    materialized = "view"
  ) 
}}

SELECT 
  -- ids 
    condition_id::VARCHAR(32) AS condition_id
  , person_id::INT AS person_id
  , member_id::INT AS member_id
  , claim_id::INT AS claim_id 

  -- varchars / text
  , "status"::VARCHAR(32) AS condition_status 
  , condition_type::VARCHAR(64) AS condition_type
  , source_code_type::VARCHAR(32) AS source_code_type
  , source_code::VARCHAR(16) AS source_code
  , normalized_code_type::VARCHAR(32) AS normalized_code_type
  , normalized_description::VARCHAR(256) AS normalized_description
  , CASE WHEN normalized_code_type = 'icd-10-cm' THEN normalized_code 
         ELSE NULL END::VARCHAR(16) AS icd_10_cm
  , mapping_method::VARCHAR(64) AS mapping_method

  -- numbers
  , condition_rank::INT AS condition_rank

  -- dates / timestamps
  , recorded_date::DATE AS recorded_date

  -- internal 
  , "data_source"::VARCHAR(64) AS _data_source
  , tuva_last_run::TIMESTAMP AS tuva_last_run_at

FROM {{ source('core', 'condition') }}