# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users/passwords', type: :request do
  path '/api/v1/users/password_forgot' do
    post('forgot password') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string }
            },
            required: ['email']
          }
        },
        required: ['user']
      }
      response(200, 'successful') do
        User.destroy_all
        let(:user) { { user: { email: 'test@uzis.com' } } }
        schema type: :object, properties: {
          user: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string }
            },
            required: ['id', 'email']
          }
        }, required: ['user']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/password_reset' do
    post('reset password') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              token: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: ['token', 'password', 'password_confirmation']
          }
        },
        required: ['user']
      }
      response(200, 'successful') do
        User.destroy_all
        existing_user = User.create(email: 'test@uzis.com', password: 'test123', password_confirmation: 'test123')
        token = existing_user.send_reset_password_instructions
        let(:user) { { user: { email: 'test@uzis.com', token:, password: 'test123', password_confirmation: 'test123' } } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
