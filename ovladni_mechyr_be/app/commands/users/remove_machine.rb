# frozen_string_literal: true

module Users
  class RemoveMachine
    prepend SimpleCommand

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      return false unless valid?

      user.update(machine: nil)
    end

    private

    def valid?
      return true if user.machine.present?

      errors.add(:user, I18n.t('commands.users.machine_not_present'))
    end
  end
end
