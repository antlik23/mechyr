# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_23_091441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "anamnestic_forms", force: :cascade do |t|
    t.datetime "completion_timestamp"
    t.integer "age"
    t.integer "height"
    t.integer "weight"
    t.boolean "on_oab_medication_last_3_months"
    t.integer "number_of_births"
    t.boolean "post_menopausal"
    t.boolean "prolapse_diagnosed"
    t.boolean "hysterectomy"
    t.integer "cesarean_section"
    t.boolean "surgery_for_benign_prostate_enlargement"
    t.boolean "surgery_for_prostate_cancer"
    t.boolean "surgery_for_bladder_tumor"
    t.boolean "surgery_for_urethral_stricture"
    t.boolean "surgery_for_urine_leakage"
    t.boolean "other_surgery"
    t.string "previous_surgery_details"
    t.boolean "recurrent_infections"
    t.boolean "neurological_surgery_history"
    t.boolean "hypertension"
    t.boolean "hypothyroidism"
    t.boolean "high_cholesterol"
    t.boolean "diabetes"
    t.boolean "back_problems"
    t.boolean "depression"
    t.boolean "other_psychiatric_conditions"
    t.boolean "reduced_immunity"
    t.boolean "headaches"
    t.boolean "hip_osteoarthritis"
    t.boolean "knee_osteoarthritis"
    t.boolean "cancer_treatment_history"
    t.boolean "cervical_cancer"
    t.boolean "endometrial_cancer"
    t.boolean "ovarian_cancer"
    t.boolean "breast_cancer"
    t.boolean "intestinal_cancer"
    t.boolean "other_cancer"
    t.string "cancer_type_details"
    t.boolean "drug_allergies"
    t.string "drug_allergies_details"
    t.boolean "glaucoma_or_eye_pressure_meds"
    t.boolean "cardiac_conditions"
    t.boolean "heart_attack"
    t.boolean "arrhythmia"
    t.boolean "stroke"
    t.boolean "digestive_problems"
    t.boolean "dry_mucous_membranes"
    t.boolean "current_medications"
    t.string "current_medications_details"
    t.boolean "past_medications"
    t.string "past_medications_details"
    t.boolean "completed"
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "no_surgery"
    t.boolean "no_illness"
    t.index ["patient_id"], name: "index_anamnestic_forms_on_patient_id"
  end

  create_table "appointment_firsts", force: :cascade do |t|
    t.date "appointment_date"
    t.boolean "consent_signed"
    t.boolean "meets_project_criteria"
    t.boolean "clinical_assessment_completed"
    t.boolean "prolapse_present"
    t.boolean "stress_test_done"
    t.boolean "stress_test_result"
    t.boolean "uti_excluded"
    t.integer "bladder_discomfort_vas"
    t.integer "diagnosis"
    t.string "alternative_diagnosis"
    t.boolean "oab_treatment_criteria_met"
    t.integer "prescribed_medication"
    t.float "dosage"
    t.integer "dosage_unit"
    t.string "alternative_dosage_unit"
    t.integer "reason_treatment_not_started"
    t.string "alternative_treatment_details"
    t.string "treatment_contraindications"
    t.date "follow_up_date"
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes"
    t.boolean "blood_in_urine"
    t.boolean "protein_in_urine"
    t.boolean "sugar_in_urine"
    t.boolean "post_void_residual_over_100_ml"
    t.index ["doctor_id"], name: "index_appointment_firsts_on_doctor_id"
    t.index ["patient_id"], name: "index_appointment_firsts_on_patient_id"
  end

  create_table "appointment_initials", force: :cascade do |t|
    t.date "assessment_date"
    t.integer "diagnosis"
    t.string "alternative_diagnosis"
    t.boolean "oab_treatment_criteria_met"
    t.boolean "initiate_pharmacological_treatment"
    t.integer "prescribed_medication"
    t.float "dosage"
    t.integer "dosage_unit"
    t.string "alternative_dosage_unit"
    t.integer "reason_treatment_not_started"
    t.string "alternative_treatment_details"
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_appointment_initials_on_doctor_id"
    t.index ["patient_id"], name: "index_appointment_initials_on_patient_id"
  end

  create_table "appointment_seconds", force: :cascade do |t|
    t.boolean "attended_appointment"
    t.date "appointment_date"
    t.integer "continuing_treatment"
    t.integer "discontinuation_reason"
    t.string "alternative_reason"
    t.integer "current_treatment"
    t.integer "prescribed_medication"
    t.float "dosage"
    t.integer "dosage_unit"
    t.string "alternative_dosage_unit"
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visual_analog_scale"
    t.string "notes"
    t.string "multiple_medications"
    t.string "multiple_medications_dosage"
    t.index ["doctor_id"], name: "index_appointment_seconds_on_doctor_id"
    t.index ["patient_id"], name: "index_appointment_seconds_on_patient_id"
  end

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "full_name"
    t.string "workplace"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "city"
    t.text "working_hours", default: "PO: 7:00 - 14:00\nUT: 7:00 - 12:00\nST: 9:00 - 17:00\nCT: 7:00 - 11:00 13:00 - 17:00\nPA: 9:00 - 12:00\nSO: Zavřeno\nNE: Zavřeno"
    t.integer "postal_code"
    t.string "street_and_number"
    t.integer "user_id"
    t.boolean "full_capacity", default: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "web"
    t.index ["user_id"], name: "index_doctors_on_user_id", unique: true
  end

  create_table "entry_forms", force: :cascade do |t|
    t.boolean "urination_frequency_issue"
    t.integer "urinations_per_day"
    t.float "fluid_intake_volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
    t.index ["patient_id"], name: "index_entry_forms_on_patient_id"
  end

  create_table "iciq_forms", force: :cascade do |t|
    t.integer "leakage_frequency"
    t.integer "leakage_assessment"
    t.integer "leakage_severity"
    t.boolean "never_leaks"
    t.boolean "leaks_before_reaching_toilet"
    t.boolean "leaks_when_coughing_or_sneezing"
    t.boolean "leaks_during_sleep"
    t.boolean "leaks_during_physical_activity"
    t.boolean "leaks_after_urinating_and_dressing"
    t.boolean "leaks_for_unknown_reasons"
    t.boolean "constant_leakage"
    t.integer "total_score"
    t.boolean "completed"
    t.datetime "completion_timestamp"
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_iciq_forms_on_patient_id"
  end

  create_table "ipss_forms", force: :cascade do |t|
    t.integer "incomplete_emptying"
    t.integer "frequency"
    t.integer "intermittent_urination"
    t.integer "urgency"
    t.integer "weak_stream"
    t.integer "straining"
    t.integer "nocturnal_urination"
    t.integer "total_score"
    t.integer "quality_of_life"
    t.boolean "completed", default: false
    t.datetime "completion_timestamp"
    t.bigint "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_ipss_forms_on_patient_id"
  end

  create_table "oab_forms", force: :cascade do |t|
    t.integer "daytime_urination_frequency"
    t.integer "unpleasant_urination_urge"
    t.integer "sudden_urination_urge"
    t.integer "occasional_leak"
    t.integer "nighttime_urination"
    t.integer "waking_up_to_urinate"
    t.integer "uncontrollable_urge"
    t.integer "leak_due_to_intense_urge"
    t.integer "total_score"
    t.boolean "completed", default: false
    t.datetime "completion_timestamp"
    t.bigint "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_oab_forms_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "full_name"
    t.integer "user_id", null: false
    t.integer "gender", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "doctor_id"
    t.boolean "approved"
    t.boolean "agreed_to_share_info", default: false
    t.datetime "next_appointment"
    t.index ["doctor_id"], name: "index_patients_on_doctor_id"
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text "invite_message"
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "voiding_diaries", force: :cascade do |t|
    t.date "diary_start_date", null: false
    t.integer "diary_duration_days", null: false
    t.time "bedtime_day_one"
    t.time "wake_up_time_day_one"
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "bedtime_day_two"
    t.time "wake_up_time_day_two"
    t.boolean "completed", default: false
    t.index ["patient_id"], name: "index_voiding_diaries_on_patient_id"
  end

  create_table "voiding_records", force: :cascade do |t|
    t.datetime "recorded_at"
    t.boolean "slept_before_and_after"
    t.boolean "urine_leakage"
    t.integer "urge_strength"
    t.integer "urine_volume"
    t.integer "beverage_type"
    t.integer "fluid_intake"
    t.bigint "voiding_diary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "urine_leakage_type"
    t.index ["voiding_diary_id"], name: "index_voiding_records_on_voiding_diary_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "anamnestic_forms", "patients"
  add_foreign_key "appointment_firsts", "doctors"
  add_foreign_key "appointment_firsts", "patients"
  add_foreign_key "appointment_initials", "doctors"
  add_foreign_key "appointment_initials", "patients"
  add_foreign_key "appointment_seconds", "doctors"
  add_foreign_key "appointment_seconds", "patients"
  add_foreign_key "iciq_forms", "patients"
  add_foreign_key "ipss_forms", "patients"
  add_foreign_key "oab_forms", "patients"
  add_foreign_key "voiding_diaries", "patients"
  add_foreign_key "voiding_records", "voiding_diaries"
end
