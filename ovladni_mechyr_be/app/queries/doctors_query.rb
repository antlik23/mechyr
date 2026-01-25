# frozen_string_literal: true

class DoctorsQuery < BaseQuery
  private

  def build_filters
    scope.where!('doctors.full_name ilike :full_name', full_name: "%#{full_name}%") if full_name.present?
    scope.where!('doctors.city ilike :city', city: "%#{city}%") if city.present?
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("doctors.#{sort_by} #{direction}"))
  end

  def full_name
    @full_name ||= params['full_name']
  end

  def workplace
    @workplace ||= params['workplace']
  end

  def street_and_number
    @street_and_number ||= params['street_and_number']
  end

  def city
    @city ||= params['city']
  end

  def build_joins
    return
  end
end
