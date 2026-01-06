# frozen_string_literal: true

module Emptyable
  extend ActiveSupport::Concern

  class_methods do
    def ignore_empty_name
      where.not(name: '').where.not(name: nil)
    end
  end
end
