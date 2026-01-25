# frozen_string_literal: true

# spec/service_parts/order_spec.rb
require 'rails_helper'

RSpec.describe Roles::CreateDefaults do
  describe '#call' do
    context 'roles are empty' do
      it 'create default roles' do
        command = described_class.call
        expect(command.success?).to be_truthy
        expect(Role.all.size).to eq(Role::ALL_ROLES.size)
      end
    end
  end
end
