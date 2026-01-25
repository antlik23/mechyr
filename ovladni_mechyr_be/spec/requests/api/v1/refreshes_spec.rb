# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/refresh_token', type: :request do
  before do
    sign_in_as(admin)
  end

  let(:Authorization) { "Bearer #{admin.access_tokens.take.refresh_token}" }

  path '/api/v1/refresh' do
    post('refresh token') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'access token refreshed' do
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
