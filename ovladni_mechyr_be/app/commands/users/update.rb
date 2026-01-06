# frozen_string_literal: true

module Users
  class Update
    prepend SimpleCommand

    attr_reader :user, :params

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      return error_messages unless update_user
      return false unless update_roles
    end

    private

    def error_messages
      errors.add(:user, user.errors.full_messages.join(', '))
    end

    def update_user
      user.update(params.except(:roles))
    end

    def update_roles
      roles_to_add.each do |role|
        user.add_role(role)
      end
      roles_to_remove.each do |role|
        user.remove_role(role)
      end
    end

    def roles_to_remove
      return existing_roles if params[:roles].blank?

      existing_roles - params[:roles]
    end

    def roles_to_add
      return [] if params[:roles].blank?

      params[:roles] - existing_roles
    end

    def existing_roles
      user.roles.pluck(:name)
    end
  end
end
