# frozen_string_literal: true

class VoidingRecordQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(recorded_at: :desc) if sort.blank?

    scope.order!(Arel.sql("voiding_records.#{sort_by} #{direction}"))
  end

  def recorded_at
    @recorded_at ||= params['recorded_at']
  end

  def slept_before_and_after
    @slept_before_and_after ||= params['slept_before_and_after']
  end

  def urine_leakage
    @urine_leakage ||= params['urine_leakage']
  end

  def urine_leakage_type
    @urine_leakage_type ||= params['urine_leakage_type']
  end

  def urge_strength
    @urge_strength ||= params['urge_strength']
  end

  def urine_volume
    @urine_volume ||= params['urine_volume']
  end

  def beverage_type
    @beverage_type ||= params['beverage_type']
  end

  def fluid_intake
    @fluid_intake ||= params['fluid_intake']
  end

  def build_joins
    return
  end
end
