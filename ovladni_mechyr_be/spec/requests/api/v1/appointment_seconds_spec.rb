# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/appointment_seconds', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/appointment_seconds' do
    get('list appointment_seconds') do
      tags 'Appointment Second'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :items_per_page, in: :query, schema: {
        type: :integer,
        description: 'Number of items per page',
        example: '20'
      }

      parameter name: :page_param, in: :query, schema: {
        type: :integer,
        description: 'Current page number',
        example: '1'
      }

      let(:items_per_page) { 30 }
      let(:page_param) { 1 }

      response(200, 'successful') do
        authorization_as_admin
        schema type: :object,
               properties: {
                 pagination: {
                   type: :object,
                   properties: {
                     count: { type: :integer },
                     page: { type: :integer },
                     next: { type: :integer, nullable: true },
                     pages: { type: :integer },
                     items: { type: :integer }
                   },
                   required: ['count', 'page', 'pages', 'items', 'next']
                 },
                 appointment_seconds: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       attended_appointment: { type: :boolean },
                       appointment_date: { type: :string, format: 'date', nullable: true },
                       visual_analog_scale: { type: :integer, nullable: true },
                       continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
                       discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'], nullable: true },
                       alternative_reason: { type: :string, nullable: true },
                       current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'], nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       id: { type: :integer },
                       notes: { type: :string, nullable: true },
                       multiple_medications: { type: :string, nullable: true },
                       multiple_medications_dosage: { type: :string, nullable: true }
                     },
                     required: ['id', 'attended_appointment', 'appointment_date', 'continuing_treatment', 'visual_analog_scale',
                                'discontinuation_reason', 'alternative_reason', 'current_treatment', 'continuing_treatment',
                                'prescribed_medication', 'dosage', 'dosage_unit', 'alternative_dosage_unit']
                   }
                 }
               },
               required: ['pagination', 'appointment_seconds']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_patient
        schema type: :object,
               properties: {
                 pagination: {
                   type: :object,
                   properties: {
                     count: { type: :integer },
                     page: { type: :integer },
                     next: { type: :integer, nullable: true },
                     pages: { type: :integer },
                     items: { type: :integer }
                   },
                   required: ['count', 'page', 'pages', 'items', 'next']
                 },
                 appointment_seconds: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       attended_appointment: { type: :boolean },
                       appointment_date: { type: :string, format: 'date', nullable: true },
                       visual_analog_scale: { type: :integer, nullable: true },
                       continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
                       discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'], nullable: true },
                       alternative_reason: { type: :string, nullable: true },
                       current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'], nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       id: { type: :integer },
                       notes: { type: :string, nullable: true },
                       multiple_medications: { type: :string, nullable: true },
                       multiple_medications_dosage: { type: :string, nullable: true }
                     },
                     required: ['id', 'attended_appointment', 'appointment_date', 'continuing_treatment', 'visual_analog_scale',
                                'discontinuation_reason', 'alternative_reason', 'current_treatment', 'continuing_treatment',
                                'prescribed_medication', 'dosage', 'dosage_unit', 'alternative_dosage_unit']
                   }
                 }
               },
               required: ['pagination', 'appointment_seconds']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_doctor
        run_test!
      end
    end

    post('create appointment_second') do
      tags 'Appointment Second'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_second, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_second: {
            type: :object,
            properties: {
              attended_appointment: { type: :boolean },
              appointment_date: { type: :string, format: 'date' },
              visual_analog_scale: { type: :integer },
              continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
              discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'] },
              alternative_reason: { type: :string },
              current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'] },
              prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              user_id: { type: :integer },
              notes: { type: :string, nullable: true },
              multiple_medications: { type: :string, nullable: true },
              multiple_medications_dosage: { type: :string, nullable: true }
            },
            required: ['attended_appointment', 'user_id']
          }
        },
        required: ['appointment_second']
      }
      let(:appointment_second) do
        {
          appointment_second: {
            attended_appointment: true,
            appointment_date: Time.current.iso8601,
            continuing_treatment: 'true',
            discontinuation_reason: 1,
            alternative_reason: 'Example Reason',
            current_treatment: 2,
            prescribed_medication: 3,
            dosage: 10.5,
            dosage_unit: 0,
            alternative_dosage_unit: 'mg',
            user_id: user_patient.id,
            notes: 'additional notes',
            multiple_medications: 'drug 1 and drug 2',
            multiple_medications_dosage: '10mg'
          }
        }
      end

      let!(:appointment_first) { create(:appointment_first, patient: patient) }

      response(201, 'successful') do
        authorization_as_doctor
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 },
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     appointment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'appointment_date']
                 }
               },
               required: ['appointment_second', 'appointment_first']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_admin
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        run_test!
      end
    end
  end

  path '/api/v1/appointment_seconds/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show appointment_second') do
      tags 'Appointment Second'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let!(:appointment_first) { create(:appointment_first, patient: patient) }

      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:appointment_second, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     attended_appointment: { type: :boolean },
                     appointment_date: { type: :string, format: 'date', nullable: true },
                     visual_analog_scale: { type: :integer, nullable: true },
                     continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
                     discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'], nullable: true },
                     alternative_reason: { type: :string, nullable: true },
                     current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'], nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     multiple_medications: { type: :string, nullable: true },
                     multiple_medications_dosage: { type: :string, nullable: true }
                   },
                   required: ['id', 'attended_appointment', 'appointment_date', 'continuing_treatment', 'doctor_user_id', 'visual_analog_scale',
                              'discontinuation_reason', 'alternative_reason', 'current_treatment', 'patient_id', 'continuing_treatment',
                              'prescribed_medication', 'dosage', 'dosage_unit', 'alternative_dosage_unit', 'patient_public_id']
                 },
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     appointment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'appointment_date']
                 }
               },
               required: ['appointment_second', 'appointment_first']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_doctor
        let(:id) { create(:appointment_second, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     attended_appointment: { type: :boolean },
                     appointment_date: { type: :string, format: 'date', nullable: true },
                     visual_analog_scale: { type: :integer, nullable: true },
                     continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
                     discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'], nullable: true },
                     alternative_reason: { type: :string, nullable: true },
                     current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'], nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     multiple_medications: { type: :string, nullable: true },
                     multiple_medications_dosage: { type: :string, nullable: true }
                   },
                   required: ['id', 'attended_appointment', 'appointment_date', 'continuing_treatment', 'doctor_user_id', 'visual_analog_scale',
                              'discontinuation_reason', 'alternative_reason', 'current_treatment', 'patient_id', 'continuing_treatment',
                              'prescribed_medication', 'dosage', 'dosage_unit', 'alternative_dosage_unit', 'patient_public_id']
                 },
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     appointment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'appointment_date']
                 }
               },
               required: ['appointment_second', 'appointment_first']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_admin
        let(:id) { create(:appointment_second, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     attended_appointment: { type: :boolean },
                     appointment_date: { type: :string, format: 'date', nullable: true },
                     visual_analog_scale: { type: :integer, nullable: true },
                     continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
                     discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'], nullable: true },
                     alternative_reason: { type: :string, nullable: true },
                     current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'], nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     multiple_medications: { type: :string, nullable: true },
                     multiple_medications_dosage: { type: :string, nullable: true }
                   },
                   required: ['id', 'attended_appointment', 'appointment_date', 'continuing_treatment', 'doctor_user_id', 'visual_analog_scale',
                              'discontinuation_reason', 'alternative_reason', 'current_treatment', 'patient_id', 'continuing_treatment',
                              'prescribed_medication', 'dosage', 'dosage_unit', 'alternative_dosage_unit', 'patient_public_id']
                 },
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     appointment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'appointment_date']
                 }
               },
               required: ['appointment_second', 'appointment_first']

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

    put('update appointment_second') do
      tags 'Appointment Second'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_second, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_second: {
            type: :object,
            properties: {
              attended_appointment: { type: :boolean },
              appointment_date: { type: :string, format: 'date' },
              visual_analog_scale: { type: :integer },
              continuing_treatment: { type: :string, enum: ['false', 'true', 'without_oab'], nullable: true },
              discontinuation_reason: { type: :string, enum: ['adverse_effects', 'treatment_ineffectiveness', 'other_reason'] },
              alternative_reason: { type: :string },
              current_treatment: { type: :string, enum: ['same_dose', 'higher_dose', 'combination', 'change_of_medication'] },
              prescribed_medication: { type: :string, enum: AppointmentSecond.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              notes: { type: :string, nullable: true },
              multiple_medications: { type: :string, nullable: true },
              multiple_medications_dosage: { type: :string, nullable: true }
            }
          }
        }, required: ['appointment_second']
      }
      let(:id) { create(:appointment_second, patient: patient).id }
      let(:appointment_second) do
        {
          appointment_second: {
            attended_appointment: false,
            appointment_date: 1.day.from_now.iso8601,
            continuing_treatment: 'false',
            discontinuation_reason: 2,
            alternative_reason: 'Updated Reason',
            current_treatment: 3,
            prescribed_medication: 4,
            dosage: 15.0,
            dosage_unit: 1,
            alternative_dosage_unit: 'ml',
            notes: 'additional notes updated',
            multiple_medications: 'drug 3 and drug 4',
            multiple_medications_dosage: '42mg'
          }
        }
      end

      response(200, 'successful') do
        authorization_as_doctor
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_second']

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        run_test!
      end

      response(200, 'successful') do
        authorization_as_admin
        schema type: :object,
               properties: {
                 appointment_second: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_second']

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

    delete('delete appointment_second') do
      tags 'Appointment Second'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:appointment_second, patient: patient).id }
      response(204, 'no content') do
        authorization_as_admin
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        run_test!
      end

      response(404, 'not found') do
        authorization_as_doctor
        run_test!
      end
    end
  end
end
