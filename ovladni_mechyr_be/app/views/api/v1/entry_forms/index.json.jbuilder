# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.entry_forms @forms do |entry_form|
  json.id entry_form.id
  json.urination_frequency_issue entry_form.urination_frequency_issue
  json.urinations_per_day entry_form.urinations_per_day
  json.fluid_intake_volume entry_form.fluid_intake_volume
end
