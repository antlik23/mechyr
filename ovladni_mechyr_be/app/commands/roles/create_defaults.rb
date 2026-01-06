# frozen_string_literal: true

module Roles
  class CreateDefaults
    prepend SimpleCommand

    def call
      create_default_roles
    end

    private

    def create_default_roles
      Role::ALL_ROLES.each do |role|
        next if Role.exists?(name: role)

        Role.create(name: role)
      end
    end
  end
end
