# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.voiding_records @forms do |voiding_record|
  json.id voiding_record.id
  json.recorded_at voiding_record.recorded_at
  json.slept_before_and_after voiding_record.slept_before_and_after
  json.urine_leakage voiding_record.urine_leakage
  json.urine_leakage_type voiding_record.urine_leakage_type
  json.urge_strength voiding_record.urge_strength
  json.urine_volume voiding_record.urine_volume
  json.beverage_type voiding_record.beverage_type
  json.fluid_intake voiding_record.fluid_intake
  json.voiding_diary_id voiding_record.voiding_diary_id
  json.record_type voiding_record.record_type
end
