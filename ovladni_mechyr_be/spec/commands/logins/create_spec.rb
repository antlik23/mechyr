# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Logins::Create do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:user) { create(:user) }

  context 'with valid email and password' do
    it 'returns a token' do
      params = { email: user.email, password: 'Test123!' }
      command = Logins::Create.call(params, request)
      expect(command.success?).to be_truthy
      expect(command.result.resource_owner_id).to eq(user.id)
    end
  end

  context 'with invalid email or password' do
    it 'returns an error message' do
      params = { email: user.email, password: 'wrongpassword' }
      command = Logins::Create.call(params, request)
      expect(command.success?).to be_falsey
      expect(command.errors[:login].first).to include('Špatné heslo, nebo e-mail.')
    end
  end
end
