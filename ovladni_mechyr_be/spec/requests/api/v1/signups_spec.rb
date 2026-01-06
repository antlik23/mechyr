# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/signups', type: :request do
  path '/api/v1/signup' do
    post('create signup') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :registration_info, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password_confirmation: { type: :string },
              password: { type: :string },
              roles: {
                type: :array,
                items: {
                  type: :string,
                  enum: ['admin', 'patient', 'doctor']
                },
                description: 'List of roles assigned to the user'
              },
              patient_attributes: {
                type: :object,
                properties: {
                  gender: { type: :string, enum: ['male', 'female', 'other'] },
                  other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'] }
                },
                required: ['gender']
              }
            },
            required: ['email', 'password_confirmation', 'password', 'roles', 'patient_attributes']
          },
          entry_form: {
            type: :integer,
            description: 'ID of the entry form',
            example: 123
          }
        },
        required: ['user', 'entry_form']
      }

      response(204, 'successful') do
        let(:entry_form) { create(:entry_form) }
        let!(:registration_info) do
          {
            user: {
              password: 'test123',
              password_confirmation: 'test123',
              email: "h#{Time.now.to_i}@prime.com",
              roles: ['patient'],
              patient_attributes: { gender: 'female' }
            },
            entry_form: entry_form.id
          }
        end
        run_test! do |response|
          expect(response).to have_http_status(:no_content)
        end
      end

      response(422, 'unprocessable entity') do
        let!(:existing_user) { create(:user, email: 'h21@prime.com') }
        let(:entry_form) { create(:entry_form) }
        let(:registration_info) do
          {
            user: {
              password: 'test123',
              password_confirmation: 'test123',
              email: 'h21@prime.com',
              roles: ['patient'],
              patient_attributes: { gender: 'female' }
            },
            entry_form: entry_form.id
          }
        end

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Email již byl použit' }
               }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Email již byl použit' }
            }
          }
        end
        run_test!
      end
    end
  end
end
