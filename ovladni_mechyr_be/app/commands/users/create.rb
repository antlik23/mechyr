# frozen_string_literal: true

module Users
  class Create
    prepend SimpleCommand

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      return error_message unless user.save
      return false unless save_roles

      user
    end

    private

    def user
      @user ||= User.new(params.except(:roles))
    end

    def save_roles
      return true if params[:roles].blank?

      params[:roles].each do |role|
        next unless Role::ALL_ROLES.include?(role.to_sym)

        user.add_role(role.to_sym)
      end
    end

    def error_message
      errors.add(:user, user.errors.full_messages.join(', '))
    end
  end
end
