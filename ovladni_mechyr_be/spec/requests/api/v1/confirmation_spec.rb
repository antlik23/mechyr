# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/confirmation', type: :request do
  path '/api/v1/resend_confirmation' do
    post('resend_confirmation') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'
      let(:valid_user) { FactoryBot.create(:user, confirmed_at: nil) }
      let(:user) do
        {
          user: {
            email: valid_user.email
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
      response(204, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/confirmation' do
    post('confirm account') do
      tags 'Logins + Passwords'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :confirmation_token, in: :query, required: true, schema: {
        type: :string,
        description: 'Confirmation token',
        example: 'o6rPjGby4zWY-fbczL1E'
      }

      response(204, 'successful') do
        let(:user) { FactoryBot.create(:user, confirmed_at: nil) }

        before do
          user.send_confirmation_instructions
        end

        let(:confirmation_token) { user.confirmation_token }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
          }
        end

        run_test!
      end
    end
  end
end
