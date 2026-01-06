# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/entry_forms', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/entry_forms' do
    get('list entry_forms') do
      tags 'Entry form'
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
                                entry_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      urination_frequency_issue: { type: :boolean },
                                      urinations_per_day: { type: :integer },
                                      fluid_intake_volume: { type: :number },
                                      patient_id: { type: :integer },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume', 'patient_id']
                                  }
                                }
                              },
               required: ['pagination', 'entry_forms']
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
                                entry_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      urination_frequency_issue: { type: :boolean },
                                      urinations_per_day: { type: :integer },
                                      fluid_intake_volume: { type: :number },
                                      patient_id: { type: :integer },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume', 'patient_id']
                                  }
                                }
                              },
               required: ['pagination', 'entry_forms']
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

    post('create entry_form') do
      tags 'Entry form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :entry_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          entry_form: {
            type: :object,
            properties: {
              urination_frequency_issue: { type: :boolean },
              urinations_per_day: { type: :integer },
              fluid_intake_volume: { type: :number }
            },
            required: ['urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume']
          }
        },
        required: ['entry_form']
      }
      let(:entry_form) { { urination_frequency_issue: true, urinations_per_day: 4, fluid_intake_volume: 1 } }
      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          entry_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              issue_present: { type: :boolean }
            },
            required: ['id', 'issue_present']
          }
        }, required: ['entry_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(201, 'successful') do
        authorization_as_doctor
        schema type: :object, properties:  {
          entry_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              issue_present: { type: :boolean }
            },
            required: ['id', 'issue_present']
          }
        }, required: ['entry_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(201, 'successful') do
        authorization_as_admin
        schema type: :object, properties:  {
          entry_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              issue_present: { type: :boolean }
            },
            required: ['id', 'issue_present']
          }
        }, required: ['entry_form']
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

  path '/api/v1/entry_forms/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show entry_form') do
      tags 'Entry form'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:id) { create(:entry_form, patient: patient).id }
        schema type: :object, properties: {
                                entry_form: {
                                  type: :object,
                                  properties: {
                                    urination_frequency_issue: { type: :boolean },
                                    urinations_per_day: { type: :integer },
                                    fluid_intake_volume: { type: :number },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string, nullable: true },
                                    patient_id: { type: :integer, nullable: true }
                                  },
                                  required: ['id', 'urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume', 'patient_id', 'patient_public_id']
                                }
                              },
               required: ['entry_form']
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
        let(:id) { create(:entry_form, patient: patient).id }
        schema type: :object, properties: {
                                entry_form: {
                                  type: :object,
                                  properties: {
                                    urination_frequency_issue: { type: :boolean },
                                    urinations_per_day: { type: :integer },
                                    fluid_intake_volume: { type: :number },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string, nullable: true },
                                    patient_id: { type: :integer, nullable: true }
                                  },
                                  required: ['id', 'urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume', 'patient_id', 'patient_public_id']
                                }
                              },
               required: ['entry_form']
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
        let(:id) { create(:entry_form, patient: patient).id }
        schema type: :object, properties: {
                                entry_form: {
                                  type: :object,
                                  properties: {
                                    urination_frequency_issue: { type: :boolean },
                                    urinations_per_day: { type: :integer },
                                    fluid_intake_volume: { type: :number },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string, nullable: true },
                                    patient_id: { type: :integer, nullable: true }
                                  },
                                  required: ['id', 'urination_frequency_issue', 'urinations_per_day', 'fluid_intake_volume', 'patient_id', 'patient_public_id']
                                }
                              },
               required: ['entry_form']
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

    put('update entry_form') do
      tags 'Entry form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :entry_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          entry_form: {
            type: :object,
            properties: {
              urination_frequency_issue: { type: :boolean },
              urinations_per_day: { type: :integer },
              fluid_intake_volume: { type: :number },
              patient_id: { type: :integer },
              id: { type: :integer }
            }
          }
        },
        required: ['entry_form']
      }
      let(:id) { create(:entry_form, patient: patient).id }
      let(:entry_form) do
        {
          entry_form: {
            fluid_intake_volume: 5,
            patient: patient
          }
        }
      end
      response(200, 'successful') do
        authorization_as_admin
        schema type: :object, properties:  {
          entry_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['entry_form']
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
        schema type: :object, properties:  {
          entry_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['entry_form']
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

    delete('delete entry_form') do
      tags 'Entry form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:entry_form, patient: patient).id }
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
