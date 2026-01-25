# frozen_string_literal: true

class AnamnesticFormQuery < BaseQuery
  private

  def build_filters
    filter_by_completion_timestamp
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("anamnestic_forms.#{sort_by} #{direction}"))
  end

  def filter_by_completion_timestamp
    return if completion_timestamp_start.blank? && completion_timestamp_end.blank?

    if completion_timestamp_start.present? && completion_timestamp_end.present?
      scope.where(completion_timestamp: completion_timestamp_start..completion_timestamp_end)
    elsif completion_timestamp_start.present?
      scope.where('completion_timestamp >=?', completion_timestamp_start)
    elsif completion_timestamp_end.present?
      scope.where('completion_timestamp <=?', completion_timestamp_end)
    end
  end

  def completion_timestamp_start
    @completion_timestamp_start ||= params['completion_timestamp_start']
  end

  def completion_timestamp_end
    @completion_timestamp_end ||= params['completion_timestamp_end']
  end

  def build_joins
    return
  end
end
