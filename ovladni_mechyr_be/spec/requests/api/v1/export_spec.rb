# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/export', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }

  describe 'Exports API', swagger_doc: 'v1/swagger.json' do
    path '/api/v1/export' do
      get 'Exports data as XLS' do
        tags 'Exports'
        produces 'application/vnd.ms-excel'
        security [Bearer: []]
        parameter name: :model_name, required: true, in: :query, schema: {
          type: :string,
          enum: ['EntryForm', 'OabForm', 'IciqForm', 'IpssForm', 'AnamnesticForm', 'VoidingDiary',
                 'AppointmentInitial', 'AppointmentFirst', 'AppointmentSecond'],
          description: 'Model name to export'
        }

        response '200', 'CSV exported successfully with only columns' do
          authorization_as_admin
          let(:model_name) { 'OabForm' }
          run_test! do |response|
            expect(response.headers['Content-Type']).to eq('application/vnd.ms-excel')
          end
        end

        response '200', 'CSV exported successfully' do
          authorization_as_admin
          let(:model_name) { 'OabForm' }
          run_test! do |response|
            expect(response.headers['Content-Type']).to eq('application/vnd.ms-excel')
          end
        end

        response(404, 'not found') do
          authorization_as_patient
          let(:model_name) { 'OabForm' }
          run_test!
        end

        response(404, 'not found') do
          authorization_as_doctor
          let(:model_name) { 'OabForm' }
          run_test!
        end
      end
    end
  end
end
