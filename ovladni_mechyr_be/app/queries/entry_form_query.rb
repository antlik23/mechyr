# frozen_string_literal: true

class EntryFormQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("entry_forms.#{sort_by} #{direction}"))
  end

  def urination_frequency_issue
    @urination_frequency_issue ||= params['urination_frequency_issue']
  end

  def urinations_per_day
    @urinations_per_day ||= params['urinations_per_day']
  end

  def fluid_intake_volume
    @fluid_intake_volume ||= params['fluid_intake_volume']
  end

  def build_joins
    return
  end
end
