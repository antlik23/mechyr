# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/iciq_forms', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/iciq_forms' do
    get('list iciq_forms') do
      tags 'ICIQ form'
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
        schema type: :object, properties: {
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
                                iciq_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      leakage_frequency: { type: :integer },
                                      leakage_assessment: { type: :integer },
                                      leakage_severity: { type: :integer },
                                      never_leaks: { type: :boolean },
                                      leaks_before_reaching_toilet: { type: :boolean },
                                      leaks_when_coughing_or_sneezing: { type: :boolean },
                                      leaks_during_sleep: { type: :boolean },
                                      leaks_during_physical_activity: { type: :boolean },
                                      leaks_after_urinating_and_dressing: { type: :boolean },
                                      leaks_for_unknown_reasons: { type: :boolean },
                                      constant_leakage: { type: :boolean },
                                      total_score: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_ipss_form: { type: :boolean },
                                      allowed_to_create_anamnestic_form: { type: :boolean }
                                    },
                                    required: ['id', 'leakage_frequency', 'leakage_assessment', 'leakage_severity', 'allowed_to_create_ipss_form',
                                               'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                                               'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                                               'leaks_for_unknown_reasons', 'constant_leakage', 'total_score', 'completed', 'allowed_to_create_anamnestic_form']
                                  }
                                }
                              },
               required: ['pagination', 'iciq_forms']
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
        schema type: :object, properties: {
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
                                iciq_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      leakage_frequency: { type: :integer },
                                      leakage_assessment: { type: :integer },
                                      leakage_severity: { type: :integer },
                                      never_leaks: { type: :boolean },
                                      leaks_before_reaching_toilet: { type: :boolean },
                                      leaks_when_coughing_or_sneezing: { type: :boolean },
                                      leaks_during_sleep: { type: :boolean },
                                      leaks_during_physical_activity: { type: :boolean },
                                      leaks_after_urinating_and_dressing: { type: :boolean },
                                      leaks_for_unknown_reasons: { type: :boolean },
                                      constant_leakage: { type: :boolean },
                                      total_score: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_ipss_form: { type: :boolean },
                                      allowed_to_create_anamnestic_form: { type: :boolean }
                                    },
                                    required: ['id', 'leakage_frequency', 'leakage_assessment', 'leakage_severity', 'allowed_to_create_ipss_form',
                                               'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                                               'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                                               'leaks_for_unknown_reasons', 'constant_leakage', 'total_score', 'completed', 'allowed_to_create_anamnestic_form']
                                  }
                                }
                              },
               required: ['pagination', 'iciq_forms']
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

    post('create iciq_form') do
      let!(:oab_form) { create(:oab_form, patient: patient, sudden_urination_urge: 4, occasional_leak: 4) }
      tags 'ICIQ form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :iciq_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          iciq_form: {
            type: :object,
            properties: {
              leakage_frequency: { type: :integer },
              leakage_assessment: { type: :integer },
              leakage_severity: { type: :integer },
              never_leaks: { type: :boolean },
              leaks_before_reaching_toilet: { type: :boolean },
              leaks_when_coughing_or_sneezing: { type: :boolean },
              leaks_during_sleep: { type: :boolean },
              leaks_during_physical_activity: { type: :boolean },
              leaks_after_urinating_and_dressing: { type: :boolean },
              leaks_for_unknown_reasons: { type: :boolean },
              constant_leakage: { type: :boolean }
            },
            required: ['leakage_frequency', 'leakage_assessment', 'leakage_severity',
                       'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                       'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                       'leaks_for_unknown_reasons', 'constant_leakage']
          }
        },
        required: ['iciq_form']
      }
      let(:iciq_form) do
        {
          iciq_form: {
            leakage_frequency: 1,
            leakage_assessment: 2,
            leakage_severity: 3,
            never_leaks: true,
            leaks_before_reaching_toilet: false,
            leaks_when_coughing_or_sneezing: true,
            leaks_during_sleep: false,
            leaks_during_physical_activity: true,
            leaks_after_urinating_and_dressing: false,
            leaks_for_unknown_reasons: true,
            constant_leakage: false,
            patient: patient
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          iciq_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 6 },
              allowed_to_create_ipss_form: { type: :boolean },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['iciq_form']
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
        authorization_as_doctor
        run_test!
      end
    end
  end

  path '/api/v1/iciq_forms/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show iciq_form') do
      tags 'ICIQ form'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:iciq_form, patient: patient).id }
        schema type: :object, properties: {
                                iciq_form: {
                                  type: :object,
                                  properties: {
                                    leakage_frequency: { type: :integer },
                                    leakage_assessment: { type: :integer },
                                    leakage_severity: { type: :integer },
                                    never_leaks: { type: :boolean },
                                    leaks_before_reaching_toilet: { type: :boolean },
                                    leaks_when_coughing_or_sneezing: { type: :boolean },
                                    leaks_during_sleep: { type: :boolean },
                                    leaks_during_physical_activity: { type: :boolean },
                                    leaks_after_urinating_and_dressing: { type: :boolean },
                                    leaks_for_unknown_reasons: { type: :boolean },
                                    constant_leakage: { type: :boolean },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_ipss_form: { type: :boolean },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'leakage_frequency', 'leakage_assessment', 'leakage_severity', 'patient_id',
                                             'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                                             'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                                             'leaks_for_unknown_reasons', 'constant_leakage', 'total_score', 'completed', 'patient_public_id',
                                             'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['iciq_form']
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
        let(:id) { create(:iciq_form, patient: patient).id }
        schema type: :object, properties: {
                                iciq_form: {
                                  type: :object,
                                  properties: {
                                    leakage_frequency: { type: :integer },
                                    leakage_assessment: { type: :integer },
                                    leakage_severity: { type: :integer },
                                    never_leaks: { type: :boolean },
                                    leaks_before_reaching_toilet: { type: :boolean },
                                    leaks_when_coughing_or_sneezing: { type: :boolean },
                                    leaks_during_sleep: { type: :boolean },
                                    leaks_during_physical_activity: { type: :boolean },
                                    leaks_after_urinating_and_dressing: { type: :boolean },
                                    leaks_for_unknown_reasons: { type: :boolean },
                                    constant_leakage: { type: :boolean },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_ipss_form: { type: :boolean },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'leakage_frequency', 'leakage_assessment', 'leakage_severity', 'patient_id',
                                             'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                                             'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                                             'leaks_for_unknown_reasons', 'constant_leakage', 'total_score', 'completed', 'patient_public_id',
                                             'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['iciq_form']
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
        let(:id) { create(:iciq_form, patient: patient).id }
        schema type: :object, properties: {
                                iciq_form: {
                                  type: :object,
                                  properties: {
                                    leakage_frequency: { type: :integer },
                                    leakage_assessment: { type: :integer },
                                    leakage_severity: { type: :integer },
                                    never_leaks: { type: :boolean },
                                    leaks_before_reaching_toilet: { type: :boolean },
                                    leaks_when_coughing_or_sneezing: { type: :boolean },
                                    leaks_during_sleep: { type: :boolean },
                                    leaks_during_physical_activity: { type: :boolean },
                                    leaks_after_urinating_and_dressing: { type: :boolean },
                                    leaks_for_unknown_reasons: { type: :boolean },
                                    constant_leakage: { type: :boolean },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_ipss_form: { type: :boolean },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'leakage_frequency', 'leakage_assessment', 'leakage_severity', 'patient_id',
                                             'never_leaks', 'leaks_before_reaching_toilet', 'leaks_when_coughing_or_sneezing',
                                             'leaks_during_sleep', 'leaks_during_physical_activity', 'leaks_after_urinating_and_dressing',
                                             'leaks_for_unknown_reasons', 'constant_leakage', 'total_score', 'completed', 'patient_public_id',
                                             'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['iciq_form']
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

    put('update iciq_form') do
      tags 'ICIQ form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :iciq_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          iciq_form: {
            type: :object,
            properties: {
              leakage_frequency: { type: :integer },
              leakage_assessment: { type: :integer },
              leakage_severity: { type: :integer },
              never_leaks: { type: :boolean },
              leaks_before_reaching_toilet: { type: :boolean },
              leaks_when_coughing_or_sneezing: { type: :boolean },
              leaks_during_sleep: { type: :boolean },
              leaks_during_physical_activity: { type: :boolean },
              leaks_after_urinating_and_dressing: { type: :boolean },
              leaks_for_unknown_reasons: { type: :boolean },
              constant_leakage: { type: :boolean }
            }
          }
        },
        required: ['iciq_form']
      }
      let(:id) { create(:iciq_form, patient: patient).id }
      let(:iciq_form) do
        {
          iciq_form: {
            leakage_frequency: 5,
            leakage_assessment: 3,
            never_leaks: false
          }
        }
      end
      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          iciq_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 11 },
              allowed_to_create_ipss_form: { type: :boolean },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['iciq_form']
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
        schema type: :object, properties:  {
          iciq_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 11 },
              allowed_to_create_ipss_form: { type: :boolean },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'allowed_to_create_ipss_form', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['iciq_form']
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

    delete('delete iciq_form') do
      tags 'ICIQ form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:iciq_form, patient: patient).id }
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
