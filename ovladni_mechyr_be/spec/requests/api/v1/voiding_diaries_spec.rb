# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/voiding_diaries', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }
  let!(:anamnestic_form) { create(:anamnestic_form, patient: patient) }

  path '/api/v1/voiding_diaries' do
    get('list voiding_diaries') do
      tags 'Voiding Diary'
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
                                voiding_diaries: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      diary_start_date: { type: :string, format: 'date' },
                                      diary_duration_days: { type: :integer },
                                      bedtime_day_one: { type: :string, format: 'time' },
                                      wake_up_time_day_one: { type: :string, format: 'time' },
                                      id: { type: :integer },
                                      bedtime_day_two: { type: :string, format: 'time' },
                                      wake_up_time_day_two: { type: :string, format: 'time' },
                                      completed: { type: :boolean }
                                    },
                                    required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one', 'completed']
                                  }
                                }
                              },
               required: ['pagination', 'voiding_diaries']
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
                                voiding_diaries: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      diary_start_date: { type: :string, format: 'date' },
                                      diary_duration_days: { type: :integer },
                                      bedtime_day_one: { type: :string, format: 'time' },
                                      wake_up_time_day_one: { type: :string, format: 'time' },
                                      id: { type: :integer },
                                      bedtime_day_two: { type: :string, format: 'time' },
                                      wake_up_time_day_two: { type: :string, format: 'time' },
                                      completed: { type: :boolean }
                                    },
                                    required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one', 'completed']
                                  }
                                }
                              },
               required: ['pagination', 'voiding_diaries']
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

    post('create voiding_diaries') do
      tags 'Voiding Diary'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :voiding_diary, in: :body, required: true, schema: {
        type: :object,
        properties: {
          voiding_diary: {
            type: :object,
            properties: {
              diary_start_date: { type: :string, format: 'date' },
              diary_duration_days: { type: :integer },
              bedtime_day_one: { type: :string, format: 'time' },
              wake_up_time_day_one: { type: :string, format: 'time' },
              bedtime_day_two: { type: :string, format: 'time' },
              wake_up_time_day_two: { type: :string, format: 'time' },
              completed: { type: :boolean },
              user_id: { type: :integer }
            },
            required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one', 'completed']
          }
        },
        required: ['voiding_diary']
      }
      let(:voiding_diary) do
        {
          voiding_diary: {
            diary_start_date: '31.1.2025',
            diary_duration_days: 1,
            bedtime_day_one: '10',
            wake_up_time_day_one: '23',
            user_id: user_patient.id
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          voiding_diary: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_diary']
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
          voiding_diary: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_diary']
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
    end
  end

  path '/api/v1/voiding_diaries/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show voiding_diary') do
      tags 'Voiding Diary'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:voiding_diary) { create(:voiding_diary, patient: patient) }
        let(:id) { voiding_diary.id }
        let!(:voiding_record) { create(:voiding_record, voiding_diary: voiding_diary) }
        schema type: :object, properties: {
                                voiding_diary: {
                                  type: :object,
                                  properties: {
                                    diary_start_date: { type: :string, format: 'date' },
                                    diary_duration_days: { type: :integer },
                                    bedtime_day_one: { type: :string, format: 'time' },
                                    wake_up_time_day_one: { type: :string, format: 'time' },
                                    bedtime_day_two: { type: :string, format: 'time' },
                                    wake_up_time_day_two: { type: :string, format: 'time' },
                                    completed: { type: :boolean },
                                    id: { type: :integer },
                                    fluid_intake_volume: { type: :integer },
                                    voided_volume: { type: :integer },
                                    nocturnal_voided_volume: { type: :integer },
                                    polyuria: { type: :boolean },
                                    nocturnal_polyuria_index: { type: :integer },
                                    frequency: { type: :integer },
                                    nocturnal_voids: { type: :integer },
                                    urgencies: { type: :integer },
                                    urgent_incontinence: { type: :integer },
                                    incontinence_episodes: { type: :integer },
                                    max_voided_volume: { type: :integer },
                                    median_voided_volume: { type: :integer },
                                    average_voided_volume: { type: :integer },
                                    patient_id: { type: :integer },
                                    patient_public_id: { type: :string }
                                  },
                                  required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one',
                                             'completed', 'patient_id', 'fluid_intake_volume', 'voided_volume', 'nocturnal_voided_volume', 'polyuria',
                                             'nocturnal_polyuria_index', 'frequency', 'nocturnal_voids', 'urgencies', 'urgent_incontinence',
                                             'incontinence_episodes', 'max_voided_volume', 'median_voided_volume', 'average_voided_volume',
                                             'patient_public_id']
                                }
                              },
               required: ['voiding_diary']
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
        let(:voiding_diary) { create(:voiding_diary, patient: patient) }
        let(:id) { voiding_diary.id }
        let!(:voiding_record) { create(:voiding_record, voiding_diary: voiding_diary) }
        schema type: :object, properties: {
                                voiding_diary: {
                                  type: :object,
                                  properties: {
                                    diary_start_date: { type: :string, format: 'date' },
                                    diary_duration_days: { type: :integer },
                                    bedtime_day_one: { type: :string, format: 'time' },
                                    wake_up_time_day_one: { type: :string, format: 'time' },
                                    id: { type: :integer },
                                    bedtime_day_two: { type: :string, format: 'time' },
                                    wake_up_time_day_two: { type: :string, format: 'time' },
                                    completed: { type: :boolean },
                                    fluid_intake_volume: { type: :integer },
                                    voided_volume: { type: :integer },
                                    nocturnal_voided_volume: { type: :integer },
                                    polyuria: { type: :boolean },
                                    nocturnal_polyuria_index: { type: :integer },
                                    frequency: { type: :integer },
                                    nocturnal_voids: { type: :integer },
                                    urgencies: { type: :integer },
                                    urgent_incontinence: { type: :integer },
                                    incontinence_episodes: { type: :integer },
                                    max_voided_volume: { type: :integer },
                                    median_voided_volume: { type: :integer },
                                    average_voided_volume: { type: :integer },
                                    patient_id: { type: :integer },
                                    patient_public_id: { type: :string }
                                  },
                                  required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one',
                                             'completed', 'patient_id', 'fluid_intake_volume', 'voided_volume', 'nocturnal_voided_volume', 'polyuria',
                                             'nocturnal_polyuria_index', 'frequency', 'nocturnal_voids', 'urgencies', 'urgent_incontinence',
                                             'incontinence_episodes', 'max_voided_volume', 'median_voided_volume', 'average_voided_volume',
                                             'patient_public_id']
                                }
                              },
               required: ['voiding_diary']
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
        let(:voiding_diary) { create(:voiding_diary, patient: patient) }
        let(:id) { voiding_diary.id }
        let!(:voiding_record) { create(:voiding_record, voiding_diary: voiding_diary) }
        schema type: :object, properties: {
                                voiding_diary: {
                                  type: :object,
                                  properties: {
                                    diary_start_date: { type: :string, format: 'date' },
                                    diary_duration_days: { type: :integer },
                                    id: { type: :integer },
                                    fluid_intake_volume: { type: :integer },
                                    voided_volume: { type: :integer },
                                    nocturnal_voided_volume: { type: :integer },
                                    polyuria: { type: :boolean },
                                    nocturnal_polyuria_index: { type: :integer },
                                    frequency: { type: :integer },
                                    nocturnal_voids: { type: :integer },
                                    urgencies: { type: :integer },
                                    urgent_incontinence: { type: :integer },
                                    incontinence_episodes: { type: :integer },
                                    max_voided_volume: { type: :integer },
                                    median_voided_volume: { type: :integer },
                                    average_voided_volume: { type: :integer },
                                    bedtime_day_one: { type: :string, format: 'time' },
                                    wake_up_time_day_one: { type: :string, format: 'time' },
                                    bedtime_day_two: { type: :string, format: 'time' },
                                    wake_up_time_day_two: { type: :string, format: 'time' },
                                    completed: { type: :boolean },
                                    patient_id: { type: :integer },
                                    patient_public_id: { type: :string }
                                  },
                                  required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one',
                                             'completed', 'patient_id', 'fluid_intake_volume', 'voided_volume', 'nocturnal_voided_volume', 'polyuria',
                                             'nocturnal_polyuria_index', 'frequency', 'nocturnal_voids', 'urgencies', 'urgent_incontinence',
                                             'incontinence_episodes', 'max_voided_volume', 'median_voided_volume', 'average_voided_volume',
                                             'patient_public_id']
                                }
                              },
               required: ['voiding_diary']
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

    put('update voiding_diary') do
      tags 'Voiding Diary'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :voiding_diary, in: :body, required: true, schema: {
        type: :object,
        properties: {
          voiding_diary: {
            type: :object,
            properties: {
              diary_start_date: { type: :string, format: 'date' },
              diary_duration_days: { type: :integer },
              bedtime_day_one: { type: :string, format: 'time' },
              wake_up_time_day_one: { type: :string, format: 'time' },
              bedtime_day_two: { type: :string, format: 'time' },
              wake_up_time_day_two: { type: :string, format: 'time' },
              completed: { type: :boolean }
            }
          }
        },
        required: ['voiding_diary']
      }
      let(:id) { create(:voiding_diary, patient: patient).id }
      let(:voiding_diary) do
        {
          voiding_diary: {
            diary_duration_days: 1,
            bedtime_day_one: 20,
            wake_up_time_day_one: 5
          }
        }
      end
      response(200, 'successful') do
        authorization_as_admin
        schema type: :object, properties:  {
          voiding_diary: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_diary']
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
          voiding_diary: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_diary']
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
        schema type: :object, properties:  {
          voiding_diary: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_diary']
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

    delete('delete voiding_diary') do
      tags 'Voiding Diary'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:voiding_diary, patient: patient).id }
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

  path '/api/v1/voiding_diaries/latest_diary' do
    get('show latest_diary') do
      tags 'Voiding Diary'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_patient
        let(:voiding_diary) { create(:voiding_diary, patient: patient) }
        let(:id) { voiding_diary.id }
        let!(:voiding_record) { create(:voiding_record, voiding_diary: voiding_diary) }
        schema type: :object, properties: {
                                voiding_diary: {
                                  type: :object,
                                  nullable: true,
                                  properties: {
                                    diary_start_date: { type: :string, format: 'date' },
                                    diary_duration_days: { type: :integer },
                                    id: { type: :integer },
                                    fluid_intake_volume: { type: :integer },
                                    voided_volume: { type: :integer },
                                    nocturnal_voided_volume: { type: :integer },
                                    polyuria: { type: :boolean },
                                    nocturnal_polyuria_index: { type: :integer },
                                    frequency: { type: :integer },
                                    nocturnal_voids: { type: :integer },
                                    urgencies: { type: :integer },
                                    urgent_incontinence: { type: :integer },
                                    incontinence_episodes: { type: :integer },
                                    max_voided_volume: { type: :integer },
                                    median_voided_volume: { type: :integer },
                                    average_voided_volume: { type: :integer },
                                    bedtime_day_one: { type: :string, format: 'time' },
                                    wake_up_time_day_one: { type: :string, format: 'time' },
                                    bedtime_day_two: { type: :string, format: 'time' },
                                    wake_up_time_day_two: { type: :string, format: 'time' },
                                    completed: { type: :boolean },
                                    patient_id: { type: :string }
                                  },
                                  required: ['id', 'diary_start_date', 'diary_duration_days', 'bedtime_day_one', 'wake_up_time_day_one',
                                             'completed', 'patient_id', 'fluid_intake_volume', 'voided_volume', 'nocturnal_voided_volume', 'polyuria',
                                             'nocturnal_polyuria_index', 'frequency', 'nocturnal_voids', 'urgencies', 'urgent_incontinence',
                                             'incontinence_episodes', 'max_voided_volume', 'median_voided_volume', 'average_voided_volume']
                                },
                                allowed_to_create_voiding_diary: { type: :boolean }
                              },
               required: ['voiding_diary', 'allowed_to_create_voiding_diary']
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
end
