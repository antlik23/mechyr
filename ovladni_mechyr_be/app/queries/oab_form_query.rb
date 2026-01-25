# frozen_string_literal: true

class OabFormQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("oab_forms.#{sort_by} #{direction}"))
  end

  def daytime_urination_frequency
    @daytime_urination_frequency ||= params[:daytime_urination_frequency]
  end

  def unpleasant_urination_urge
    @unpleasant_urination_urge ||= params[:unpleasant_urination_urge]
  end

  def sudden_urination_urge
    @sudden_urination_urge ||= params[:sudden_urination_urge]
  end

  def occasional_leak
    @occasional_leak ||= params[:occasional_leak]
  end

  def nighttime_urination
    @nighttime_urination ||= params[:nighttime_urination]
  end

  def waking_up_to_urinate
    @waking_up_to_urinate ||= params[:waking_up_to_urinate]
  end

  def uncontrollable_urge
    @uncontrollable_urge ||= params[:uncontrollable_urge]
  end

  def leak_due_to_intense_urge
    @leak_due_to_intense_urge ||= params[:leak_due_to_intense_urge]
  end

  def total_score
    @total_score ||= params[:total_score]
  end

  def completed
    @completed ||= params[:completed]
  end

  def completion_timestamp
    @completion_timestamp ||= params[:completion_timestamp]
  end

  def patient_id
    @patient_id ||= params[:patient_id]
  end

  def build_joins
    return
  end
end
