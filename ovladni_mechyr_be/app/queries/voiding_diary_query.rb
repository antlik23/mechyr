# frozen_string_literal: true

class VoidingDiaryQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(diary_start_date: :desc) if sort.blank?

    scope.order!(Arel.sql("voiding_diaries.#{sort_by} #{direction}"))
  end

  def diary_start_date
    @diary_start_date ||= params['diary_start_date']
  end

  def diary_duration_days
    @diary_duration_days ||= params['diary_duration_days']
  end

  def build_joins
    return
  end
end
