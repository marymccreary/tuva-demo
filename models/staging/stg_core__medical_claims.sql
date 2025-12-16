{{ config(
    materialized = "view"
  ) 
}}

SELECT
    -- IDs
    medical_claim_id::VARCHAR(32) AS medical_claim_id
  , claim_id::INT AS claim_id
  , encounter_id::INT AS encounter_id
  , person_id::INT AS person_id
  , member_id::INT AS member_id
  , rendering_id::INT AS rendering_id

    -- Booleans
  , in_network_flag::BOOLEAN AS is_in_network
  , enrollment_flag::BOOLEAN AS is_enrolled

    -- Varchars / Text
  , encounter_type::VARCHAR(64) AS encounter_type
  , encounter_group::VARCHAR(64) AS encounter_group
  , claim_type::VARCHAR(32) AS claim_type
  , payer::VARCHAR(128) AS payer
  , plan::VARCHAR(128) AS plan
  , service_category_1::VARCHAR(128) AS service_category_1
  , service_category_2::VARCHAR(128) AS service_category_2
  , service_category_3::VARCHAR(128) AS service_category_3
  , place_of_service_code::VARCHAR(16) AS place_of_service_code
  , place_of_service_description::VARCHAR(256) AS place_of_service_description
  , bill_type_code::VARCHAR(16) AS bill_type_code
  , bill_type_description::VARCHAR(256) AS bill_type_description
  , drg_code_type::VARCHAR(32) AS drg_code_type
  , drg_code::VARCHAR(16) AS drg_code
  , drg_description::VARCHAR(256) AS drg_description
  , rendering_name::VARCHAR(256) AS rendering_name

    -- Numbers
  , claim_line_number::INT AS claim_line_number
  , service_unit_quantity::INT AS service_unit_quantity
  , member_month_key::BIGINT AS member_month_key
  , paid_amount::NUMERIC AS paid_amount
  , allowed_amount::NUMERIC AS allowed_amount
  , charge_amount::NUMERIC AS charge_amount

  , ROUND(paid_amount * 100, 0) AS paid_amount_cents
  , ROUND(allowed_amount * 100, 0) AS allowed_amount_cents
  , ROUND(charge_amount * 100, 0) AS charge_amount_cents

    -- Dates / timestamps
  , claim_start_date::DATE AS claim_start_date
  , claim_end_date::DATE AS claim_end_date
  , claim_line_start_date::DATE AS claim_line_start_date
  , claim_line_end_date::DATE AS claim_line_end_date
  , admission_date::DATE AS admission_date
  , discharge_date::DATE AS discharge_date
  , paid_date::DATE AS paid_date
  , file_date::DATE AS file_date

    -- internal
  , "data_source"::VARCHAR(64) AS _data_source
  , tuva_last_run::TIMESTAMP AS _tuva_last_run_at

FROM {{ source('core', 'medical_claim') }}
