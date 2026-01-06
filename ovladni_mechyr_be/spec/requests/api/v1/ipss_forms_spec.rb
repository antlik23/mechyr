# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/ipss_forms', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor, gender: 'male') }

  path '/api/v1/ipss_forms' do
    get('list ipss_forms') do
      tags 'IPSS form'
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
                                ipss_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      incomplete_emptying: { type: :integer },
                                      frequency: { type: :integer },
                                      intermittent_urination: { type: :integer },
                                      urgency: { type: :integer },
                                      weak_stream: { type: :integer },
                                      straining: { type: :integer },
                                      nocturnal_urination: { type: :integer },
                                      total_score: { type: :integer },
                                      quality_of_life: { type: :integer },
                                      life_quality_index: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_anamnestic_form: { type: :boolean }
                                    },
                                    required: ['id', 'incomplete_emptying', 'frequency', 'intermittent_urination', 'allowed_to_create_anamnestic_form',
                                               'urgency', 'weak_stream', 'straining', 'nocturnal_urination',
                                               'total_score', 'quality_of_life', 'life_quality_index', 'completed']
                                  }
                                }
                              },
               required: ['pagination', 'ipss_forms']
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
                                ipss_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      incomplete_emptying: { type: :integer },
                                      frequency: { type: :integer },
                                      intermittent_urination: { type: :integer },
                                      urgency: { type: :integer },
                                      weak_stream: { type: :integer },
                                      straining: { type: :integer },
                                      nocturnal_urination: { type: :integer },
                                      total_score: { type: :integer },
                                      quality_of_life: { type: :integer },
                                      life_quality_index: { type: :integer },
                                      completed: { type: :boolean },
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      id: { type: :integer },
                                      allowed_to_create_anamnestic_form: { type: :boolean }
                                    },
                                    required: ['id', 'incomplete_emptying', 'frequency', 'intermittent_urination', 'allowed_to_create_anamnestic_form',
                                               'urgency', 'weak_stream', 'straining', 'nocturnal_urination',
                                               'total_score', 'quality_of_life', 'life_quality_index', 'completed']
                                  }
                                }
                              },
               required: ['pagination', 'ipss_forms']
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

    post('create ipss_form') do
      let!(:iciq_form) { create(:iciq_form, patient: patient, completed: true) }

      tags 'IPSS form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :ipss_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          ipss_form: {
            type: :object,
            properties: {
              incomplete_emptying: { type: :integer },
              frequency: { type: :integer },
              intermittent_urination: { type: :integer },
              urgency: { type: :integer },
              weak_stream: { type: :integer },
              straining: { type: :integer },
              nocturnal_urination: { type: :integer },
              quality_of_life: { type: :integer }
            },
            required: ['incomplete_emptying', 'frequency', 'intermittent_urination',
                       'urgency', 'weak_stream', 'straining', 'nocturnal_urination',
                       'quality_of_life']
          }
        },
        required: ['ipss_form']
      }
      let(:ipss_form) do
        {
          ipss_form: {
            incomplete_emptying: 1,
            frequency: 2,
            intermittent_urination: 3,
            urgency: 4,
            weak_stream: 1,
            straining: 2,
            nocturnal_urination: 3,
            quality_of_life: 4,
            patient_id: patient.id
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
          ipss_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 15 },
              life_quality_index: { type: :integer, example: 5 },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'life_quality_index', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['ipss_form']
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

  path '/api/v1/ipss_forms/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show ipss_form') do
      tags 'IPSS form'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:ipss_form, patient: patient).id }
        schema type: :object, properties: {
                                ipss_form: {
                                  type: :object,
                                  properties: {
                                    incomplete_emptying: { type: :integer },
                                    frequency: { type: :integer },
                                    intermittent_urination: { type: :integer },
                                    urgency: { type: :integer },
                                    weak_stream: { type: :integer },
                                    straining: { type: :integer },
                                    nocturnal_urination: { type: :integer },
                                    total_score: { type: :integer },
                                    quality_of_life: { type: :integer },
                                    life_quality_index: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'incomplete_emptying', 'frequency', 'intermittent_urination', 'patient_id',
                                             'urgency', 'weak_stream', 'straining', 'nocturnal_urination', 'patient_public_id',
                                             'total_score', 'quality_of_life', 'life_quality_index', 'completed', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['ipss_form']
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
        let(:id) { create(:ipss_form, patient: patient).id }
        schema type: :object, properties: {
                                ipss_form: {
                                  type: :object,
                                  properties: {
                                    incomplete_emptying: { type: :integer },
                                    frequency: { type: :integer },
                                    intermittent_urination: { type: :integer },
                                    urgency: { type: :integer },
                                    weak_stream: { type: :integer },
                                    straining: { type: :integer },
                                    nocturnal_urination: { type: :integer },
                                    total_score: { type: :integer },
                                    quality_of_life: { type: :integer },
                                    life_quality_index: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'incomplete_emptying', 'frequency', 'intermittent_urination', 'patient_id',
                                             'urgency', 'weak_stream', 'straining', 'nocturnal_urination', 'patient_public_id',
                                             'total_score', 'quality_of_life', 'life_quality_index', 'completed', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['ipss_form']
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
        let(:id) { create(:ipss_form, patient: patient).id }
        schema type: :object, properties: {
                                ipss_form: {
                                  type: :object,
                                  properties: {
                                    incomplete_emptying: { type: :integer },
                                    frequency: { type: :integer },
                                    intermittent_urination: { type: :integer },
                                    urgency: { type: :integer },
                                    weak_stream: { type: :integer },
                                    straining: { type: :integer },
                                    nocturnal_urination: { type: :integer },
                                    total_score: { type: :integer },
                                    quality_of_life: { type: :integer },
                                    life_quality_index: { type: :integer },
                                    completed: { type: :boolean },
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    allowed_to_create_anamnestic_form: { type: :boolean }
                                  },
                                  required: ['id', 'incomplete_emptying', 'frequency', 'intermittent_urination', 'patient_id',
                                             'urgency', 'weak_stream', 'straining', 'nocturnal_urination', 'patient_public_id',
                                             'total_score', 'quality_of_life', 'life_quality_index', 'completed', 'allowed_to_create_anamnestic_form']
                                }
                              },
               required: ['ipss_form']
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

    put('update ipss_form') do
      tags 'IPSS form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :ipss_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          ipss_form: {
            type: :object,
            properties: {
              incomplete_emptying: { type: :integer },
              frequency: { type: :integer },
              intermittent_urination: { type: :integer },
              urgency: { type: :integer },
              weak_stream: { type: :integer },
              straining: { type: :integer },
              nocturnal_urination: { type: :integer },
              quality_of_life: { type: :integer }
            }
          }
        },
        required: ['ipss_form']
      }
      let(:id) { create(:ipss_form, patient: patient).id }
      let(:ipss_form) do
        {
          ipss_form: {
            incomplete_emptying: 5,
            frequency: 4
          }
        }
      end
      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
          ipss_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 15 },
              life_quality_index: { type: :integer, example: 5 },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'life_quality_index', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['ipss_form']
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
        schema type: :object, properties: {
          ipss_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              total_score: { type: :integer, example: 15 },
              life_quality_index: { type: :integer, example: 5 },
              allowed_to_create_anamnestic_form: { type: :boolean }
            },
            required: ['id', 'total_score', 'life_quality_index', 'allowed_to_create_anamnestic_form']
          }
        }, required: ['ipss_form']
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

    delete('delete ipss_form') do
      tags 'IPSS form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:ipss_form, patient: patient).id }
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
