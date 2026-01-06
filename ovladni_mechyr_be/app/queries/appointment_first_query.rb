# frozen_string_literal: true

class AppointmentFirstQuery < BaseQuery
  private

  def build_filters
    filter_by_appointment_date
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("appointment_firsts.#{sort_by} #{direction}"))
  end

  def filter_by_appointment_date
    return if appointment_date_start.blank? && appointment_date_end.blank?

    if appointment_date_start.present? && appointment_date_end.present?
      scope.where(appointment_date: appointment_date_start..appointment_date_end)
    elsif appointment_date_start.present?
      scope.where('appointment_date >=?', appointment_date_start)
    elsif appointment_date_end.present?
      scope.where('appointment_date <=?', appointment_date_end)
    end
  end

  def appointment_date_start
    @appointment_date_start ||= params['appointment_date_start']
  end

  def appointment_date_end
    @appointment_date_end ||= params['appointment_date_end']
  end

  def build_joins
    return
  end
end
