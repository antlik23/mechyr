# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Update do
  describe '#call' do
    let(:user) { create(:user, first_name: 'original name') }

    it 'update name' do
      command = described_class.call(user, name_params)
      expect(command.success?).to be_truthy
      expect(user.reload.first_name).to eq('updated name')
    end

    it 'update multiple roles' do
      command = described_class.call(user, roles_params)
      expect(command.success?).to be_truthy
      expect(user.reload.admin?).to be_truthy
      expect(user.patient?).to be_truthy
    end

    it 'remove roles' do
      user.add_role(:patient)
      command = described_class.call(user, remove_roles_params)
      expect(command.success?).to be_truthy
      expect(user.reload.admin?).to be_truthy
      expect(user.patient?).to be_falsey
    end
  end

  private

  def roles_params
    {
      roles: ['admin', 'patient']
    }
  end

  def remove_roles_params
    {
      roles: ['admin']
    }
  end

  def name_params
    {
      first_name: 'updated name'
    }
  end
end
