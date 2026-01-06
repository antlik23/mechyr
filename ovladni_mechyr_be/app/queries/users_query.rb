# frozen_string_literal: true

class UsersQuery < BaseQuery
  private

  def build_filters
    scope.where!('users.full_name ilike :full_name', full_name: "%#{full_name}%") if full_name.present?
    filter_by_last_active if last_active_from.present? || last_active_to.present?
    scope_by_roles if roles.present?
  end

  def order_collection(sort_by, direction)
    return scope.order!(:id) if sort.blank?

    scope.order!(Arel.sql("users.#{sort_by} #{direction}"))
  end

  def scope_by_roles
    scope.where!(roles: { name: roles })
  end

  def roles
    @roles ||= Array(params[:roles]).select do |role|
      Role::ALL_ROLES.include?(role.to_sym)
    end
  end

  def full_name
    @full_name ||= params['full_name']
  end

  def last_active_from
    @last_active_from ||= params['last_active_from']
  end

  def last_active_to
    @last_active_to ||= params['last_active_to']
  end

  def build_joins
    return
  end

  def filter_by_last_active
    if last_active_from.present? && last_active_to.present?
      scope.where!(current_sign_in_at: last_active_from.to_datetime..last_active_to.to_datetime)
    elsif last_active_from.blank? && last_active_to.present?
      scope.where!(current_sign_in_at: DateTime.new(2024, 1, 1)..last_active_to.to_datetime)
    elsif last_active_from.present? && last_active_to.blank?
      scope.where!(current_sign_in_at: last_active_from.to_datetime..Date::Infinity.new)
    end
  end
end
