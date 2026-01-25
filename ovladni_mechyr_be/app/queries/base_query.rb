# frozen_string_literal: true

class BaseQuery
  prepend SimpleCommand

  attr_reader :scope, :params

  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def call
    build_joins
    build_filters
    build_sorts
    scope
  end

  private

  def build_sorts
    order_collection(sort, direction)
  end

  def sort
    @sort ||= params['sort_by']
  end

  def direction
    @direction ||= params['direction'] || 'asc'
  end

  def order_collection(sort_by, direction)
    raise NotImplementedError, 'order_collection must be implemented in the child class'
  end

  def build_filters
    raise NotImplementedError, 'build_filters must be implemented in the child class'
  end

  def build_joins
    raise NotImplementedError, 'build_joins must be implemented in the child class'
  end
end
