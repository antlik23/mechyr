# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/logins', type: :request do
  let!(:admin) { FactoryBot.create(:user_admin, email: 'tester@test.com') }
  let(:user) { { email: 'tester@test.com', password: 'Test123!' } }

  path '/api/v1/login' do
    post('create login') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'tester@test.com' },
          password: { type: :string, example: 'test123' }
        },
        required: ['email', 'password']
      }
      response '200', 'user logged in' do
        schema type: :object, properties: {
          access_token: {
            type: :string,
            description: 'Access token for authentication',
            example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
          },
          refresh_token: {
            type: :string,
            description: 'Token used to refresh the access token',
            example: '8xLOxBtZp8'
          },
          expires_in: {
            type: :integer,
            description: 'Time in seconds until the access token expires',
            example: 3600
          },
          user: {
            type: :object,
            properties: {
              id: {
                type: :integer,
                description: "User's unique identifier",
                example: 1
              },
              email: {
                type: :string,
                description: "User's email address",
                example: 'user@example.com'
              },
              gender: {
                type: :string, enum: ['male', 'female'], nullable: true,
                description: "User's gender",
                example: 'male'
              },
              patient_public_id: {
                type: :string, nullable: true,
                description: "Patient's public ID",
                example: '00000001'
              },
              roles: {
                type: :array,
                items: {
                  type: :string, enum: ['patient', 'doctor', 'admin'],
                  example: 'patient'
                },
                description: 'List of roles assigned to the user'
              }
            },
            required: ['id', 'email', 'roles', 'gender', 'patient_public_id']
          }
        }, required: ['user', 'access_token', 'refresh_token', 'expires_in']

        let(:user) { { email: 'tester@test.com', password: 'Test123!' } }
        run_test!
      end
      response '401', 'invalid request' do
        let(:user) { { email: 'tester@test.com', password: '' } }
        run_test!
      end
    end
  end
end
