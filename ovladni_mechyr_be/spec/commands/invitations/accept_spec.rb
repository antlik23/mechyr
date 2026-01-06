# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitations::Accept do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:user) { User.invite!(email: 'invited@user.com') }

  context 'with valid email and password' do
    it 'returns a token' do
      params = { password: 'password123', password_confirmation: 'password123', invitation_token: user.raw_invitation_token }
      command = Invitations::Accept.call(params, request)
      expect(command.success?).to be_truthy
      expect(command.result.resource_owner_id).to eq(user.id)
    end
  end

  context 'with invalid email or password' do
    it 'returns an error message' do
      params = { password: 'wrongpassword' }
      command = Invitations::Accept.call(params, request)
      expect(command.result).to be_falsey
    end
  end
end
