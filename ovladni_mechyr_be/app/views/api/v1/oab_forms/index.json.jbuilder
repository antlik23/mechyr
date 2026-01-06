# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.oab_forms @forms do |oab_form|
  json.id oab_form.id
  json.daytime_urination_frequency oab_form.daytime_urination_frequency
  json.unpleasant_urination_urge oab_form.unpleasant_urination_urge
  json.sudden_urination_urge oab_form.sudden_urination_urge
  json.occasional_leak oab_form.occasional_leak
  json.nighttime_urination oab_form.nighttime_urination
  json.waking_up_to_urinate oab_form.waking_up_to_urinate
  json.uncontrollable_urge oab_form.uncontrollable_urge
  json.leak_due_to_intense_urge oab_form.leak_due_to_intense_urge
  json.total_score oab_form.total_score
  json.completed oab_form.completed
  json.completion_timestamp oab_form.completion_timestamp
  json.allowed_to_create_iciq_form oab_form.patient.allowed_to_create_iciq_form
end
