# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create do
  describe '#call' do
    it 'create user' do
      command = described_class.call(user_params)
      expect(command.success?).to be_truthy
      expect(command.result.first_name).to eq('new name')
      expect(command.result.last_name).to eq('new last_name')
    end

    it 'create user with multiple roles' do
      command = described_class.call(user_params_with_roles)
      expect(command.success?).to be_truthy
      expect(command.result.roles.size).to eq(2)
      expect(command.result.admin?).to be_truthy
      expect(command.result.patient?).to be_truthy
    end
  end

  private

  def user_params
    {
      email: 'user@example.com',
      first_name: 'new name',
      last_name: 'new last_name',
      password: 'test123',
      password_confirmation: 'test123'
    }
  end

  def user_params_with_roles
    {
      email: 'user@example.com',
      first_name: 'new name',
      last_name: 'new last_name',
      password: 'test123',
      password_confirmation: 'test123',
      roles: ['admin', 'patient']
    }
  end
end
