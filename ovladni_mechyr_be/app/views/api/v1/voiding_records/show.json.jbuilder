# frozen_string_literal: true

json.voiding_record do
  json.id @form.id
  json.recorded_at @form.recorded_at
  json.slept_before_and_after @form.slept_before_and_after
  json.urine_leakage @form.urine_leakage
  json.urine_leakage_type @form.urine_leakage_type
  json.urge_strength @form.urge_strength
  json.urine_volume @form.urine_volume
  json.beverage_type @form.beverage_type
  json.fluid_intake @form.fluid_intake
  json.voiding_diary_id @form.voiding_diary_id
  json.record_type @form.record_type
end
