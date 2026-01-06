# frozen_string_literal: true

module Users
  class AddMachine
    prepend SimpleCommand

    attr_reader :user, :machine

    def initialize(user, machine)
      @user = user
      @machine = machine
    end

    def call
      return false unless valid?

      user.update(machine:)
    end

    private

    def valid?
      return true if user.machine.blank?

      errors.add(:user, I18n.t('errors.messages.already_in_use', resource: I18n.t('activerecord.models.machine'), person: I18n.t('activerecord.models.user')))
      false
    end
  end
end
