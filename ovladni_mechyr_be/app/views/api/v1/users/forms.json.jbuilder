# frozen_string_literal: true

json.set! 'forms' do
  if @oab_forms.present?
    json.oab_forms @oab_forms do |form|
      json.id form.id
      json.completion_timestamp form.completion_timestamp.iso8601
      json.total_score form.total_score if form.respond_to?(:total_score)
    end
  else
    json.oab_forms []
  end
  if @ipss_forms.present?
    json.ipss_forms @ipss_forms do |form|
      json.id form.id
      json.completion_timestamp form.completion_timestamp.iso8601
      json.total_score form.total_score if form.respond_to?(:total_score)
    end
  else
    json.ipss_forms []
  end
  if @iciq_forms.present?
    json.iciq_forms @iciq_forms do |form|
      json.id form.id
      json.completion_timestamp form.completion_timestamp.iso8601
      json.total_score form.total_score if form.respond_to?(:total_score)
    end
  else
    json.iciq_forms []
  end
  if @anamnestic_forms.present?
    json.anamnestic_forms @anamnestic_forms do |form|
      json.id form.id
      json.completion_timestamp form.completion_timestamp.iso8601
      json.total_score nil
    end
  else
    json.anamnestic_forms []
  end
end
