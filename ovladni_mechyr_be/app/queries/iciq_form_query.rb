# frozen_string_literal: true

class IciqFormQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("iciq_forms.#{sort_by} #{direction}"))
  end

  def leakage_frequency
    @leakage_frequency ||= params['leakage_frequency']
  end

  def leakage_assessment
    @leakage_assessment ||= params['leakage_assessment']
  end

  def leakage_severity
    @leakage_severity ||= params['leakage_severity']
  end

  def never_leaks
    @never_leaks ||= params['never_leaks']
  end

  def leaks_before_reaching_toilet
    @leaks_before_reaching_toilet ||= params['leaks_before_reaching_toilet']
  end

  def leaks_when_coughing_or_sneezing
    @leaks_when_coughing_or_sneezing ||= params['leaks_when_coughing_or_sneezing']
  end

  def leaks_during_sleep
    @leaks_during_sleep ||= params['leaks_during_sleep']
  end

  def leaks_during_physical_activity
    @leaks_during_physical_activity ||= params['leaks_during_physical_activity']
  end

  def leaks_after_urinating_and_dressing
    @leaks_after_urinating_and_dressing ||= params['leaks_after_urinating_and_dressing']
  end

  def leaks_for_unknown_reasons
    @leaks_for_unknown_reasons ||= params['leaks_for_unknown_reasons']
  end

  def constant_leakage
    @constant_leakage ||= params['constant_leakage']
  end

  def total_score
    @total_score ||= params['total_score']
  end

  def completion_timestamp
    @completion_timestamp ||= params['completion_timestamp']
  end

  def build_joins
    return
  end
end
