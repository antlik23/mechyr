# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.ipss_forms @forms do |ipss_form|
  json.id ipss_form.id
  json.incomplete_emptying ipss_form.incomplete_emptying
  json.frequency ipss_form.frequency
  json.intermittent_urination ipss_form.intermittent_urination
  json.urgency ipss_form.urgency
  json.weak_stream ipss_form.weak_stream
  json.straining ipss_form.straining
  json.nocturnal_urination ipss_form.nocturnal_urination
  json.total_score ipss_form.total_score
  json.quality_of_life ipss_form.quality_of_life
  json.life_quality_index ipss_form.quality_of_life
  json.completed ipss_form.completed
  json.completion_timestamp ipss_form.completion_timestamp
  json.allowed_to_create_anamnestic_form ipss_form.patient.allowed_to_create_anamnestic_form
end
