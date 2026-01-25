# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/oab_forms', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/oab_forms' do
    get('list oab_forms') do
      tags 'OAB form'
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
                                oab_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      daytime_urination_frequency: { type: :integer },
                                      unpleasant_urination_urge: { type: :integer },
                                      sudden_urination_urge: { type: :integer },
                                      occasional_leak: { type: :integer },
                                      nighttime_urination: { type: :integer },
                                      waking_up_to_urinate: { type: :integer },
                                      uncontrollable_urge: { type: :integer },
                                      leak_due_to_intense_urge: { type: :integer },
                                      total_score: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_iciq_form: { type: :boolean }
                                    },
                                    required: ['id', 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                                               'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                                               'leak_due_to_intense_urge', 'total_score', 'completed', 'allowed_to_create_iciq_form']
                                  }
                                }
                              },
               required: ['pagination', 'oab_forms']
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
                                oab_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      daytime_urination_frequency: { type: :integer },
                                      unpleasant_urination_urge: { type: :integer },
                                      sudden_urination_urge: { type: :integer },
                                      occasional_leak: { type: :integer },
                                      nighttime_urination: { type: :integer },
                                      waking_up_to_urinate: { type: :integer },
                                      uncontrollable_urge: { type: :integer },
                                      leak_due_to_intense_urge: { type: :integer },
                                      total_score: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_iciq_form: { type: :boolean }
                                    },
                                    required: ['id', 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                                               'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                                               'leak_due_to_intense_urge', 'total_score', 'completed', 'allowed_to_create_iciq_form']
                                  }
                                }
                              },
               required: ['pagination', 'oab_forms']
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

    post('create oab_form') do
      tags 'OAB form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :oab_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          oab_form: {
            type: :object,
            properties: {
              daytime_urination_frequency: { type: :integer },
              unpleasant_urination_urge: { type: :integer },
              sudden_urination_urge: { type: :integer },
              occasional_leak: { type: :integer },
              nighttime_urination: { type: :integer },
              waking_up_to_urinate: { type: :integer },
              uncontrollable_urge: { type: :integer },
              leak_due_to_intense_urge: { type: :integer }
            },
            required: ['daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                       'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                       'leak_due_to_intense_urge']
          }
        },
        required: ['oab_form']
      }
      let(:patient) { create(:patient) }
      let(:oab_form) do
        {
          oab_form: {
            daytime_urination_frequency: 1,
            unpleasant_urination_urge: 2,
            sudden_urination_urge: 3,
            occasional_leak: 4,
            nighttime_urination: 1,
            waking_up_to_urinate: 2,
            uncontrollable_urge: 3,
            leak_due_to_intense_urge: 4,
            patient_id: patient.id
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          oab_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 12 },
              allowed_to_create_iciq_form: { type: :boolean },
              gender: { type: :string, enum: ['male', 'female'] }
            },
            required: ['id', 'total_score', 'allowed_to_create_iciq_form', 'gender']
          }
        }, required: ['oab_form']
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

  path '/api/v1/oab_forms/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show oab_form') do
      tags 'OAB form'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:oab_form, patient: patient).id }
        schema type: :object, properties: {
                                oab_form: {
                                  type: :object,
                                  properties: {
                                    daytime_urination_frequency: { type: :integer },
                                    unpleasant_urination_urge: { type: :integer },
                                    sudden_urination_urge: { type: :integer },
                                    occasional_leak: { type: :integer },
                                    nighttime_urination: { type: :integer },
                                    waking_up_to_urinate: { type: :integer },
                                    uncontrollable_urge: { type: :integer },
                                    leak_due_to_intense_urge: { type: :integer },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_iciq_form: { type: :boolean },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                                             'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                                             'leak_due_to_intense_urge', 'total_score', 'completed', 'patient_id', 'patient_public_id',
                                             'allowed_to_create_iciq_form', 'gender']
                                }
                              },
               required: ['oab_form']
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
        let(:id) { create(:oab_form, patient: patient).id }
        schema type: :object, properties: {
                                oab_form: {
                                  type: :object,
                                  properties: {
                                    daytime_urination_frequency: { type: :integer },
                                    unpleasant_urination_urge: { type: :integer },
                                    sudden_urination_urge: { type: :integer },
                                    occasional_leak: { type: :integer },
                                    nighttime_urination: { type: :integer },
                                    waking_up_to_urinate: { type: :integer },
                                    uncontrollable_urge: { type: :integer },
                                    leak_due_to_intense_urge: { type: :integer },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_iciq_form: { type: :boolean },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                                             'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                                             'leak_due_to_intense_urge', 'total_score', 'completed', 'patient_id', 'patient_public_id',
                                             'allowed_to_create_iciq_form', 'gender']
                                }
                              },
               required: ['oab_form']
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
        let(:id) { create(:oab_form, patient: patient).id }
        schema type: :object, properties: {
                                oab_form: {
                                  type: :object,
                                  properties: {
                                    daytime_urination_frequency: { type: :integer },
                                    unpleasant_urination_urge: { type: :integer },
                                    sudden_urination_urge: { type: :integer },
                                    occasional_leak: { type: :integer },
                                    nighttime_urination: { type: :integer },
                                    waking_up_to_urinate: { type: :integer },
                                    uncontrollable_urge: { type: :integer },
                                    leak_due_to_intense_urge: { type: :integer },
                                    total_score: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_iciq_form: { type: :boolean },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge',
                                             'occasional_leak', 'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge',
                                             'leak_due_to_intense_urge', 'total_score', 'completed', 'patient_id', 'patient_public_id',
                                             'allowed_to_create_iciq_form', 'gender']
                                }
                              },
               required: ['oab_form']
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

    put('update oab_form') do
      tags 'OAB form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :oab_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          oab_form: {
            type: :object,
            properties: {
              daytime_urination_frequency: { type: :integer },
              unpleasant_urination_urge: { type: :integer },
              sudden_urination_urge: { type: :integer },
              occasional_leak: { type: :integer },
              nighttime_urination: { type: :integer },
              waking_up_to_urinate: { type: :integer },
              uncontrollable_urge: { type: :integer },
              leak_due_to_intense_urge: { type: :integer }
            }
          }
        },
        required: ['oab_form']
      }
      let(:id) { create(:oab_form, patient: patient).id }
      let(:oab_form) do
        {
          oab_form: {
            daytime_urination_frequency: 5,
            unpleasant_urination_urge: 4
          }
        }
      end
      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          oab_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 12 },
              allowed_to_create_iciq_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'allowed_to_create_iciq_form']
          }
        }, required: ['oab_form']
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
          oab_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 12 },
              allowed_to_create_iciq_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'allowed_to_create_iciq_form']
          }
        }, required: ['oab_form']
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

    delete('delete oab_form') do
      tags 'OAB form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:oab_form, patient: patient).id }
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
