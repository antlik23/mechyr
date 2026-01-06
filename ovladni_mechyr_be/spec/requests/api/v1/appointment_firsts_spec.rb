# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/appointment_firsts', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/appointment_firsts' do
    get('list appointment_firsts') do
      tags 'Appointment First'
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
                 appointment_firsts: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       appointment_date: { type: :string, format: 'date' },
                       consent_signed: { type: :boolean },
                       meets_project_criteria: { type: :boolean, nullable: true },
                       clinical_assessment_completed: { type: :boolean, nullable: true },
                       prolapse_present: { type: :boolean, nullable: true },
                       stress_test_done: { type: :boolean, nullable: true },
                       stress_test_result: { type: :boolean, nullable: true },
                       uti_excluded: { type: :boolean, nullable: true },
                       bladder_discomfort_vas: { type: :integer, nullable: true },
                       diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'], nullable: true },
                       alternative_diagnosis: { type: :string, nullable: true },
                       oab_treatment_criteria_met: { type: :boolean, nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       reason_treatment_not_started: { type: :string,
                                                       enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                              'contraindications_to_treatment', 'patient_refused_treatment'],
                                                       nullable: true },
                       alternative_treatment_details: { type: :string, nullable: true },
                       treatment_contraindications: { type: :string, nullable: true },
                       follow_up_date: { type: :string, format: 'date' },
                       id: { type: :integer },
                       notes: { type: :string, nullable: true },
                       blood_in_urine: { type: :boolean, nullable: true },
                       protein_in_urine: { type: :boolean, nullable: true },
                       sugar_in_urine: { type: :boolean, nullable: true },
                       post_void_residual_over_100_ml: { type: :boolean, nullable: true }
                     },
                     required: ['id', 'appointment_date', 'consent_signed', 'meets_project_criteria', 'clinical_assessment_completed',
                                'prolapse_present', 'stress_test_done', 'stress_test_result', 'uti_excluded', 'bladder_discomfort_vas',
                                'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'prescribed_medication',
                                'dosage', 'dosage_unit', 'alternative_dosage_unit', 'reason_treatment_not_started',
                                'alternative_treatment_details', 'treatment_contraindications', 'follow_up_date',
                                'blood_in_urine', 'protein_in_urine', 'sugar_in_urine', 'post_void_residual_over_100_ml']

                   }
                 }
               },
               required: ['pagination', 'appointment_firsts']

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
                 appointment_firsts: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       appointment_date: { type: :string, format: 'date' },
                       consent_signed: { type: :boolean },
                       meets_project_criteria: { type: :boolean, nullable: true },
                       clinical_assessment_completed: { type: :boolean, nullable: true },
                       prolapse_present: { type: :boolean, nullable: true },
                       stress_test_done: { type: :boolean, nullable: true },
                       stress_test_result: { type: :boolean, nullable: true },
                       uti_excluded: { type: :boolean, nullable: true },
                       bladder_discomfort_vas: { type: :integer, nullable: true },
                       diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'], nullable: true },
                       alternative_diagnosis: { type: :string, nullable: true },
                       oab_treatment_criteria_met: { type: :boolean, nullable: true },
                       prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys, nullable: true },
                       dosage: { type: :number, nullable: true },
                       dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                       alternative_dosage_unit: { type: :string, nullable: true },
                       reason_treatment_not_started: { type: :string,
                                                       enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                              'contraindications_to_treatment', 'patient_refused_treatment'],
                                                       nullable: true },
                       alternative_treatment_details: { type: :string, nullable: true },
                       treatment_contraindications: { type: :string, nullable: true },
                       follow_up_date: { type: :string, format: 'date' },
                       id: { type: :integer },
                       notes: { type: :string, nullable: true },
                       blood_in_urine: { type: :boolean, nullable: true },
                       protein_in_urine: { type: :boolean, nullable: true },
                       sugar_in_urine: { type: :boolean, nullable: true },
                       post_void_residual_over_100_ml: { type: :boolean, nullable: true }
                     },
                     required: ['id', 'appointment_date', 'consent_signed', 'meets_project_criteria', 'clinical_assessment_completed',
                                'prolapse_present', 'stress_test_done', 'stress_test_result', 'uti_excluded', 'bladder_discomfort_vas',
                                'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'prescribed_medication',
                                'dosage', 'dosage_unit', 'alternative_dosage_unit', 'reason_treatment_not_started',
                                'alternative_treatment_details', 'treatment_contraindications', 'follow_up_date']
                   }
                 }
               },
               required: ['pagination', 'appointment_firsts']

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

    post('create appointment_first') do
      tags 'Appointment First'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_first, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_first: {
            type: :object,
            properties: {
              appointment_date: { type: :string, format: 'date' },
              consent_signed: { type: :boolean },
              meets_project_criteria: { type: :boolean },
              clinical_assessment_completed: { type: :boolean },
              prolapse_present: { type: :boolean },
              stress_test_done: { type: :boolean },
              stress_test_result: { type: :boolean },
              uti_excluded: { type: :boolean },
              bladder_discomfort_vas: { type: :integer },
              diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
              alternative_diagnosis: { type: :string },
              oab_treatment_criteria_met: { type: :boolean },
              prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              reason_treatment_not_started: { type: :string,
                                              enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                     'contraindications_to_treatment', 'patient_refused_treatment'] },
              alternative_treatment_details: { type: :string },
              treatment_contraindications: { type: :string },
              follow_up_date: { type: :string, format: 'date' },
              user_id: { type: :integer },
              notes: { type: :string, nullable: true },
              blood_in_urine: { type: :boolean, nullable: true },
              protein_in_urine: { type: :boolean, nullable: true },
              sugar_in_urine: { type: :boolean, nullable: true },
              post_void_residual_over_100_ml: { type: :boolean, nullable: true }
            },
            required: ['appointment_date', 'consent_signed', 'user_id']
          }
        },
        required: ['appointment_first']
      }
      let(:appointment_first) do
        {
          appointment_first: {
            appointment_date: Time.current.iso8601,
            consent_signed: true,
            meets_project_criteria: true,
            clinical_assessment_completed: true,
            prolapse_present: false,
            stress_test_done: true,
            stress_test_result: false,
            uti_excluded: true,
            bladder_discomfort_vas: 5,
            diagnosis: 1,
            alternative_diagnosis: 'Example Diagnosis',
            oab_treatment_criteria_met: true,
            prescribed_medication: 2,
            dosage: 10.5,
            dosage_unit: 0,
            alternative_dosage_unit: 'mg',
            reason_treatment_not_started: 1,
            alternative_treatment_details: 'Additional details',
            treatment_contraindications: 'No contraindications',
            follow_up_date: 1.week.from_now.iso8601,
            user_id: user_patient.id,
            notes: 'additional notes'
          }
        }
      end

      let!(:appointment_initial) { create(:appointment_initial, patient: patient) }

      response(201, 'successful') do
        authorization_as_doctor
        schema type: :object,
               properties: {
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 },
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     assessment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'assessment_date']
                 }
               },
               required: ['appointment_first', 'appointment_initial']

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

  path '/api/v1/appointment_firsts/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show appointment_first') do
      tags 'Appointment First'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let!(:appointment_initial) { create(:appointment_initial, patient: patient) }

      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:appointment_first, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_first: {
                   type: :object,
                   properties: {
                     appointment_date: { type: :string, format: 'date' },
                     consent_signed: { type: :boolean },
                     meets_project_criteria: { type: :boolean, nullable: true },
                     clinical_assessment_completed: { type: :boolean, nullable: true },
                     prolapse_present: { type: :boolean, nullable: true },
                     stress_test_done: { type: :boolean, nullable: true },
                     stress_test_result: { type: :boolean, nullable: true },
                     uti_excluded: { type: :boolean, nullable: true },
                     bladder_discomfort_vas: { type: :integer, nullable: true },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'], nullable: true },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string,
                                                     enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                            'contraindications_to_treatment', 'patient_refused_treatment'],
                                                     nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     treatment_contraindications: { type: :string, nullable: true },
                     follow_up_date: { type: :string, format: 'date' },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     blood_in_urine: { type: :boolean, nullable: true },
                     protein_in_urine: { type: :boolean, nullable: true },
                     sugar_in_urine: { type: :boolean, nullable: true },
                     post_void_residual_over_100_ml: { type: :boolean, nullable: true }
                   },
                   required: ['id', 'appointment_date', 'consent_signed', 'meets_project_criteria', 'clinical_assessment_completed',
                              'prolapse_present', 'stress_test_done', 'stress_test_result', 'uti_excluded', 'bladder_discomfort_vas',
                              'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'prescribed_medication', 'patient_public_id',
                              'dosage', 'dosage_unit', 'alternative_dosage_unit', 'reason_treatment_not_started', 'patient_id',
                              'alternative_treatment_details', 'treatment_contraindications', 'follow_up_date', 'doctor_user_id']
                 },
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     assessment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'assessment_date']
                 }
               },
               required: ['appointment_first', 'appointment_initial']

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
        let(:id) { create(:appointment_first, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_first: {
                   type: :object,
                   properties: {
                     appointment_date: { type: :string, format: 'date' },
                     consent_signed: { type: :boolean },
                     meets_project_criteria: { type: :boolean, nullable: true },
                     clinical_assessment_completed: { type: :boolean, nullable: true },
                     prolapse_present: { type: :boolean, nullable: true },
                     stress_test_done: { type: :boolean, nullable: true },
                     stress_test_result: { type: :boolean, nullable: true },
                     uti_excluded: { type: :boolean, nullable: true },
                     bladder_discomfort_vas: { type: :integer, nullable: true },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'], nullable: true },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string,
                                                     enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                            'contraindications_to_treatment', 'patient_refused_treatment'],
                                                     nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     treatment_contraindications: { type: :string, nullable: true },
                     follow_up_date: { type: :string, format: 'date' },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     blood_in_urine: { type: :boolean, nullable: true },
                     protein_in_urine: { type: :boolean, nullable: true },
                     sugar_in_urine: { type: :boolean, nullable: true },
                     post_void_residual_over_100_ml: { type: :boolean, nullable: true }
                   },
                   required: ['id', 'appointment_date', 'consent_signed', 'meets_project_criteria', 'clinical_assessment_completed',
                              'prolapse_present', 'stress_test_done', 'stress_test_result', 'uti_excluded', 'bladder_discomfort_vas',
                              'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'prescribed_medication', 'patient_public_id',
                              'dosage', 'dosage_unit', 'alternative_dosage_unit', 'reason_treatment_not_started', 'patient_id',
                              'alternative_treatment_details', 'treatment_contraindications', 'follow_up_date', 'doctor_user_id']
                 },
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     assessment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'assessment_date']
                 }
               },
               required: ['appointment_first', 'appointment_initial']

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
        let(:id) { create(:appointment_first, patient: patient).id }
        schema type: :object,
               properties: {
                 appointment_first: {
                   type: :object,
                   properties: {
                     appointment_date: { type: :string, format: 'date' },
                     consent_signed: { type: :boolean },
                     meets_project_criteria: { type: :boolean, nullable: true },
                     clinical_assessment_completed: { type: :boolean, nullable: true },
                     prolapse_present: { type: :boolean, nullable: true },
                     stress_test_done: { type: :boolean, nullable: true },
                     stress_test_result: { type: :boolean, nullable: true },
                     uti_excluded: { type: :boolean, nullable: true },
                     bladder_discomfort_vas: { type: :integer, nullable: true },
                     diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'], nullable: true },
                     alternative_diagnosis: { type: :string, nullable: true },
                     oab_treatment_criteria_met: { type: :boolean, nullable: true },
                     prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys, nullable: true },
                     dosage: { type: :number, nullable: true },
                     dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'], nullable: true },
                     alternative_dosage_unit: { type: :string, nullable: true },
                     reason_treatment_not_started: { type: :string,
                                                     enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                            'contraindications_to_treatment', 'patient_refused_treatment'],
                                                     nullable: true },
                     alternative_treatment_details: { type: :string, nullable: true },
                     treatment_contraindications: { type: :string, nullable: true },
                     follow_up_date: { type: :string, format: 'date' },
                     id: { type: :integer },
                     doctor_user_id: { type: :integer },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     notes: { type: :string, nullable: true },
                     blood_in_urine: { type: :boolean, nullable: true },
                     protein_in_urine: { type: :boolean, nullable: true },
                     sugar_in_urine: { type: :boolean, nullable: true },
                     post_void_residual_over_100_ml: { type: :boolean, nullable: true }
                   },
                   required: ['id', 'appointment_date', 'consent_signed', 'meets_project_criteria', 'clinical_assessment_completed',
                              'prolapse_present', 'stress_test_done', 'stress_test_result', 'uti_excluded', 'bladder_discomfort_vas',
                              'diagnosis', 'alternative_diagnosis', 'oab_treatment_criteria_met', 'prescribed_medication', 'patient_public_id',
                              'dosage', 'dosage_unit', 'alternative_dosage_unit', 'reason_treatment_not_started', 'patient_id',
                              'alternative_treatment_details', 'treatment_contraindications', 'follow_up_date', 'doctor_user_id']
                 },
                 appointment_initial: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     assessment_date: { type: :string, format: 'date' }
                   },
                   required: ['id', 'assessment_date']
                 }
               },
               required: ['appointment_first', 'appointment_initial']

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

    put('update appointment_first') do
      tags 'Appointment First'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :appointment_first, in: :body, required: true, schema: {
        type: :object,
        properties: {
          appointment_first: {
            type: :object,
            properties: {
              appointment_date: { type: :string, format: 'date' },
              consent_signed: { type: :boolean },
              meets_project_criteria: { type: :boolean },
              clinical_assessment_completed: { type: :boolean },
              prolapse_present: { type: :boolean },
              stress_test_done: { type: :boolean },
              stress_test_result: { type: :boolean },
              uti_excluded: { type: :boolean },
              bladder_discomfort_vas: { type: :integer },
              diagnosis: { type: :string, enum: ['without_oab', 'oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess', 'other_diagnosis'] },
              alternative_diagnosis: { type: :string },
              oab_treatment_criteria_met: { type: :boolean },
              prescribed_medication: { type: :string, enum: AppointmentFirst.prescribed_medications.keys },
              dosage: { type: :number },
              dosage_unit: { type: :string, enum: ['mg', 'ml', 'other_unit'] },
              alternative_dosage_unit: { type: :string },
              reason_treatment_not_started: { type: :string,
                                              enum: ['other_treatment', 'unable_to_propose_treatment', 'no_therapy_needed',
                                                     'contraindications_to_treatment', 'patient_refused_treatment'] },
              alternative_treatment_details: { type: :string },
              treatment_contraindications: { type: :string },
              follow_up_date: { type: :string, format: 'date' },
              notes: { type: :string, nullable: true },
              blood_in_urine: { type: :boolean, nullable: true },
              protein_in_urine: { type: :boolean, nullable: true },
              sugar_in_urine: { type: :boolean, nullable: true },
              post_void_residual_over_100_ml: { type: :boolean, nullable: true }
            }
          }
        },
        required: ['appointment_first']
      }
      let(:id) { create(:appointment_first, patient: patient).id }
      let(:appointment_first) do
        {
          appointment_first: {
            appointment_date: 1.day.from_now.iso8601,
            consent_signed: false,
            meets_project_criteria: false,
            clinical_assessment_completed: false,
            prolapse_present: true,
            stress_test_done: false,
            stress_test_result: true,
            uti_excluded: false,
            bladder_discomfort_vas: 8,
            diagnosis: 2,
            alternative_diagnosis: 'Updated Diagnosis',
            oab_treatment_criteria_met: false,
            prescribed_medication: 3,
            dosage: 15.0,
            dosage_unit: 1,
            alternative_dosage_unit: 'ml',
            reason_treatment_not_started: 2,
            alternative_treatment_details: 'Updated details',
            treatment_contraindications: 'Updated contraindications',
            follow_up_date: 2.weeks.from_now.iso8601,
            notes: 'additional notes updated'
          }
        }
      end

      response(200, 'successful') do
        authorization_as_doctor
        schema type: :object,
               properties: {
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_first']

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
                 appointment_first: {
                   type: :object,
                   properties: {
                     id: { type: :integer }
                   },
                   required: ['id']
                 }
               },
               required: ['appointment_first']

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

    delete('delete appointment_first') do
      tags 'Appointment First'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:appointment_first, patient: patient).id }
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
