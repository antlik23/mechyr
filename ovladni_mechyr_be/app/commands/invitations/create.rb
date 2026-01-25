# frozen_string_literal: true

module Invitations
  class Create
    prepend SimpleCommand

    attr_reader :user, :params

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      return false if accepted?

      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless user_invite
        raise ActiveRecord::Rollback unless save_roles
      end
      user_invite
    end

    private

    def accepted?
      existing_user = User.find_by(email: params[:email])
      if existing_user.present?
        if existing_user.invitation_accepted_at.present?
          errors.add(:invitation, I18n.t('errors.messages.invitation_accepted'))
          return true if existing_user.invitation_accepted_at.present?
        end
        if existing_user.email == user.email
          errors.add(:invitation, I18n.t('errors.messages.can_not_invite_yourself'))
          return true if existing_user.invitation_accepted_at.present?
        end
      end
      false
    end

    def user_invite
      @user_invite ||= User.invite!(params.except(:roles), user)
    end

    def save_roles
      return true if params[:roles].blank?

      params[:roles].each do |role|
        next unless Role::ALL_ROLES.include?(role.to_sym)

        user_invite.add_role(role.to_sym)
      end
    end
  end
end
