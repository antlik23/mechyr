# frozen_string_literal: true

class IpssFormQuery < BaseQuery
  private

  def build_filters
    return
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("ipss_forms.#{sort_by} #{direction}"))
  end

  def incomplete_emptying
    @incomplete_emptying ||= params[:incomplete_emptying]
  end

  def frequency
    @frequency ||= params[:frequency]
  end

  def intermittent_urination
    @intermittent_urination ||= params[:intermittent_urination]
  end

  def urgency
    @urgency ||= params[:urgency]
  end

  def weak_stream
    @weak_stream ||= params[:weak_stream]
  end

  def straining
    @straining ||= params[:straining]
  end

  def nocturnal_urination
    @nocturnal_urination ||= params[:nocturnal_urination]
  end

  def quality_of_life
    @quality_of_life ||= params[:quality_of_life]
  end

  def build_joins
    return
  end
end
