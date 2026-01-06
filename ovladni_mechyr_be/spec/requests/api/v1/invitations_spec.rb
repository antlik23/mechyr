# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/invitations', type: :request do
  before do
    sign_in_as(admin)
  end

  let(:Authorization) { "Bearer #{admin.access_tokens.take.access_token}" }

  path '/api/v1/resend_invitation' do
    post('resend invitation') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      let!(:invited_user) do
        User.invite!(email: 'invited@user.com')
      end

      let(:user) do
        {
          user: {
            id: invited_user.id
          }
        }
      end

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              id: { type: :integer }
            }
          }
        }
      }

      response(201, 'successful') do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer, description: "Customer's unique identifier", example: 1 }
                   },
                   required: ['id']
                 }
               },
               required: ['user']
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

  path '/api/v1/invitation' do
    let!(:invited_user) do
      User.invite!(email: 'invited@user.com')
    end
    put('accept invitation') do
      let!(:doctor) { create(:doctor, user_id: invited_user.id) }

      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'

      let(:user) do
        {
          user: {
            password: 'asldkfj3o4930jfkls',
            password_confirmation: 'asldkfj3o4930jfkls',
            invitation_token: invited_user.raw_invitation_token,
            roles: 'doctor'
          }
        }
      end

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              password: { type: :string },
              password_confirmation: { type: :string },
              invitation_token: { type: :string },
              doctor_attributes: {
                type: :object,
                properties: {
                  full_name: { type: :string }
                },
                required: ['full_name']
              }
            },
            required: ['password', 'password_confirmation', 'invitation_token', 'doctor_attributes']
          }
        },
        required: ['user']
      }

      response(202, 'accepted') do
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
              roles: {
                type: :array,
                items: {
                  type: :string, enum: ['patient', 'doctor', 'admin']
                },
                description: 'List of roles assigned to the user'
              }
            },
            required: ['id', 'email', 'gender', 'roles']
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

    post('create invitation') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      let(:user) do
        {
          user: {
            email: 'a26@uzis.com'
          }
        }
      end

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

      response(201, 'successful') do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer, description: "Customer's unique identifier", example: 1 }
                   },
                   required: ['id']
                 }
               },
               required: ['user']
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
