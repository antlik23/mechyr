# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/appointment_initials', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/appointment_initials' do
    get('list appointment_initials') do
      tags 'Appointment Initial'
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
                 appointment_initials: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       assessment_date: { type: :string, format: 'date' },
                       diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
                       alternative_diagnosis: { type: :string, nullable: true },
                       oab_treatment_criteria_met: { type: :boolean, nullable: true },
                       initiate_pharmacological_treatment: { type: :boolean, nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'], nullable: true },
                       alternative_treatment_details: { type: :string, nullable: true },
                       id: { type: :integer }
                     },
                     required: ['id', 'assessment_date', 'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met',
                                'initiate_pharmacological_treatment', 'prescribed_medication', 'dosage', 'dosage_unit',
                                'alternative_dosage_unit', 'reason_treatment_not_started', 'alternative_treatment_details']
                   }
                 }
               },
               required: ['pagination', 'appointment_initials']

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
                 appointment_initials: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       assessment_date: { type: :string, format: 'date' },
                       diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
                       alternative_diagnosis: { type: :string, nullable: true },
                       oab_treatment_criteria_met: { type: :boolean, nullable: true },
                       initiate_pharmacological_treatment: { type: :boolean, nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'], nullable: true },
                       alternative_treatment_details: { type: :string, nullable: true },
                       id: { type: :integer }
                     },
                     required: ['id', 'assessment_date', 'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met',
                                'initiate_pharmacological_treatment', 'prescribed_medication', 'dosage', 'dosage_unit',
                                'alternative_dosage_unit', 'reason_treatment_not_started', 'alternative_treatment_details']
                   }
                 }
               },
               required: ['pagination', 'appointment_initials']

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

    post('create appointment_initial') do
      tags 'Appointment Initial'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_initial, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_initial: {
            type: :object,
            properties: {
              assessment_date: { type: :string, format: 'date' },
              diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
              alternative_diagnosis: { type: :string },
              oab_treatment_criteria_met: { type: :boolean },
              initiate_pharmacological_treatment: { type: :boolean },
              prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'] },
              alternative_treatment_details: { type: :string },
              user_id: { type: :integer }
            },
            required: ['assessment_date', 'diagnosis', 'user_id']
          }
        },
        required: ['appointment_initial']
      }
      let(:appointment_initial) do
        {
          appointment_initial: {
            assessment_date: Time.current.iso8601,
            diagnosis: 1,
            alternative_diagnosis: 'Example Diagnosis',
            oab_treatment_criteria_met: true,
            initiate_pharmacological_treatment: false,
            prescribed_medication: 2,
            dosage: 10.5,
            dosage_unit: 0,
            alternative_dosage_unit: 'mg',
            reason_treatment_not_started: 1,
            alternative_treatment_details: 'Additional details',
            user_id: user_patient.id
          }
        }
      end

      response(201, 'successful') do
        authorization_as_doctor
        schema type: :object,
               properties: {
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_initial']

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

  path '/api/v1/appointment_initials/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show appointment_initial') do
      tags 'Appointment Initial'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:appointment_initial, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_initial: {
                   type: :object,
                   properties: {
                     assessment_date: { type: :string, format: 'date' },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     initiate_pharmacological_treatment: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'], nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer }
                   },
                   required: ['id', 'assessment_date', 'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'doctor_user_id',
                              'initiate_pharmacological_treatment', 'prescribed_medication', 'dosage', 'dosage_unit', 'patient_id',
                              'alternative_dosage_unit', 'reason_treatment_not_started', 'alternative_treatment_details', 'patient_public_id']
                 }
               },
               required: ['appointment_initial']

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
        let(:id) { create(:appointment_initial, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_initial: {
                   type: :object,
                   properties: {
                     assessment_date: { type: :string, format: 'date' },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     initiate_pharmacological_treatment: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'], nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer }
                   },
                   required: ['id', 'assessment_date', 'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'doctor_user_id',
                              'initiate_pharmacological_treatment', 'prescribed_medication', 'dosage', 'dosage_unit', 'patient_id',
                              'alternative_dosage_unit', 'reason_treatment_not_started', 'alternative_treatment_details', 'patient_public_id']
                 }
               },
               required: ['appointment_initial']

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
        let(:id) { create(:appointment_initial, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_initial: {
                   type: :object,
                   properties: {
                     assessment_date: { type: :string, format: 'date' },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     initiate_pharmacological_treatment: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'], nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer }
                   },
                   required: ['id', 'assessment_date', 'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'doctor_user_id',
                              'initiate_pharmacological_treatment', 'prescribed_medication', 'dosage', 'dosage_unit', 'patient_id',
                              'alternative_dosage_unit', 'reason_treatment_not_started', 'alternative_treatment_details', 'patient_public_id']
                 }
               },
               required: ['appointment_initial']

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

    put('update appointment_initial') do
      tags 'Appointment Initial'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_initial, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_initial: {
            type: :object,
            properties: {
              assessment_date: { type: :string, format: 'date' },
              diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
              alternative_diagnosis: { type: :string },
              oab_treatment_criteria_met: { type: :boolean },
              initiate_pharmacological_treatment: { type: :boolean },
              prescribed_medication: { type: :string, enum: AppointmentInitial.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              reason_treatment_not_started: { type: :string, enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed'] },
              alternative_treatment_details: { type: :string }
            }
          }
        },
        required: ['appointment_initial']
      }
      let(:id) { create(:appointment_initial, patient: patient).id }
      let(:appointment_initial) do
        {
          appointment_initial: {
            assessment_date: 1.day.from_now.iso8601,
            diagnosis: 2,
            alternative_diagnosis: 'Updated Diagnosis',
            oab_treatment_criteria_met: false,
            initiate_pharmacological_treatment: true,
            prescribed_medication: 3,
            dosage: 15.0,
            dosage_unit: 1,
            alternative_dosage_unit: 'ml',
            reason_treatment_not_started: 2,
            alternative_treatment_details: 'Updated details'
          }
        }
      end

      response(200, 'successful') do
        authorization_as_admin
        schema type: :object,
               properties: {
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_initial']

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

      response(404, 'not found') do
        authorization_as_doctor
        run_test!
      end
    end

    delete('delete appointment_initial') do
      tags 'Appointment Initial'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:appointment_initial, patient: patient).id }
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
