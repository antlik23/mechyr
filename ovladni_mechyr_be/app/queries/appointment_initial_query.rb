# frozen_string_literal: true

class AppointmentInitialQuery < BaseQuery
  private

  def build_filters
    filter_by_assessment_date
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("appointment_initials.#{sort_by} #{direction}"))
  end

  def filter_by_assessment_date
    return if assessment_date_start.blank? && assessment_date_end.blank?

    if assessment_date_start.present? && assessment_date_end.present?
      scope.where(assessment_date: assessment_date_start..assessment_date_end)
    elsif assessment_date_start.present?
      scope.where('assessment_date >=?', assessment_date_start)
    elsif assessment_date_end.present?
      scope.where('assessment_date <=?', assessment_date_end)
    end
  end

  def assessment_date_start
    @assessment_date_start ||= params['assessment_date_start']
  end

  def assessment_date_end
    @assessment_date_end ||= params['assessment_date_end']
  end

  def build_joins
    return
  end
end
