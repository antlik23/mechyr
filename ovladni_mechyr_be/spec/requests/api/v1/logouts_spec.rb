# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Logins', type: :request do
  describe 'POST /api/v1/login' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      before do
        post '/api/v1/login', as: :json, params: { email: user.email, password: user.password }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid credentials' do
      before do
        post '/api/v1/login', params: { email: user.email, password: 'invalid_password' }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not sign in the user' do
        expect(response.headers['Authorization']).to be_blank
      end
    end
  end
end
