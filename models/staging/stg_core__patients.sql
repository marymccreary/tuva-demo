{{ config(
    materialized = "view"
  ) 
}}

SELECT 
    -- ids 
      person_id::VARCHAR(32) AS person_id

    -- booleans
    , death_flag::BOOLEAN AS is_deceased    

    -- varchars / text
    , sex::VARCHAR(16) AS sex
    , race::VARCHAR(16) AS race
    , "state"::VARCHAR(32) AS address_state
    , age_group::VARCHAR(32) AS age_group

    -- numbers 
    , age::INT AS age

    -- dates / timestamps
    , birth_date::DATE AS birth_date
    , death_date::DATE AS death_date    
    -- internal 
    , "data_source"::VARCHAR(64) AS _data_source
    , tuva_last_run::TIMESTAMP AS _tuva_last_run_at

from {{ source('core', 'patient') }}
