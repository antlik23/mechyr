# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/voiding_diaries/{voiding_diary_id}/voiding_records', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }

  let(:patient) { create(:patient, user: user_patient) }
  let(:voiding_diary) { create(:voiding_diary, patient: patient) }
  let(:voiding_diary_id) { voiding_diary.id }

  path '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records' do
    get('list voiding records') do
      tags 'Voiding Records'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :voiding_diary_id, in: :path, type: :integer, description: 'voiding_diary_id'
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

      parameter name: :direction, in: :query, schema: {
        type: :string, enum: ['asc', 'desc'],
        description: 'Direction of sorting',
        example: 'asc'
      }

      let(:direction) { '' }
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
                                voiding_records: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      recorded_at: { type: :string, format: 'date-time' },
                                      slept_before_and_after: { type: :boolean },
                                      urine_leakage: { type: :boolean },
                                      urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                      urge_strength: { type: :integer },
                                      urine_volume: { type: :integer },
                                      beverage_type: { type: :string,
                                                       enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                      fluid_intake: { type: :integer },
                                      record_type: { type: :string, enum: ['input', 'output'] },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'recorded_at', 'record_type']
                                  }
                                }
                              },
               required: ['pagination', 'voiding_records']
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
                                voiding_records: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      recorded_at: { type: :string, format: 'date-time' },
                                      slept_before_and_after: { type: :boolean },
                                      urine_leakage: { type: :boolean },
                                      urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                      urge_strength: { type: :integer },
                                      urine_volume: { type: :integer },
                                      beverage_type: { type: :string,
                                                       enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                      fluid_intake: { type: :integer },
                                      record_type: { type: :string, enum: ['input', 'output'] },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'recorded_at', 'record_type']
                                  }
                                }
                              },
               required: ['pagination', 'voiding_records']
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
                                voiding_records: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      recorded_at: { type: :string, format: 'date-time' },
                                      slept_before_and_after: { type: :boolean },
                                      urine_leakage: { type: :boolean },
                                      urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                      urge_strength: { type: :integer },
                                      urine_volume: { type: :integer },
                                      beverage_type: { type: :string,
                                                       enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                      fluid_intake: { type: :integer },
                                      record_type: { type: :string, enum: ['input', 'output'] },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'recorded_at', 'record_type']
                                  }
                                }
                              },
               required: ['pagination', 'voiding_records']
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

    post('create voiding record') do
      tags 'Voiding Records'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :voiding_diary_id, in: :path, type: :integer, description: 'voiding_diary_id'
      parameter name: :voiding_record, in: :body, required: true, schema: {
        type: :object,
        properties: {
          voiding_record: {
            type: :object,
            properties: {
              recorded_at: { type: :string, format: 'date-time' },
              slept_before_and_after: { type: :boolean },
              urine_leakage: { type: :boolean },
              urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
              urge_strength: { type: :integer },
              urine_volume: { type: :integer },
              beverage_type: { type: :string,
                               enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
              fluid_intake: { type: :integer }
            },
            required: ['recorded_at']
          }
        },
        required: ['voiding_record']
      }
      let(:voiding_diary) { create(:voiding_diary) }

      let(:voiding_record) do
        {
          voiding_record: {
            recorded_at: DateTime.now,
            slept_before_and_after: true,
            urine_leakage: false,
            urine_leakage_type: 'stressful',
            urge_strength: 3,
            urine_volume: 250,
            beverage_type: 1,
            fluid_intake: 300,
            voiding_diary_id: voiding_diary.id
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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
        schema type: :object, properties: {
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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
        schema type: :object, properties: {
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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

  path '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}' do
    parameter name: :voiding_diary_id, in: :path, type: :integer, description: 'voiding_diary_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show voiding record') do
      tags 'Voiding Records'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]

      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:voiding_record, voiding_diary: voiding_diary).id }
        schema type: :object, properties: {
                                voiding_record: {
                                  type: :object,
                                  properties: {
                                    recorded_at: { type: :string, format: 'date-time' },
                                    slept_before_and_after: { type: :boolean },
                                    urine_leakage: { type: :boolean },
                                    urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                    urge_strength: { type: :integer },
                                    urine_volume: { type: :integer },
                                    beverage_type: { type: :string,
                                                     enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                    fluid_intake: { type: :integer },
                                    record_type: { type: :string, enum: ['input', 'output'] },
                                    id: { type: :integer }
                                  },
                                  required: ['id', 'recorded_at', 'record_type']
                                }
                              },
               required: ['voiding_record']
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
        let(:id) { create(:voiding_record, voiding_diary: voiding_diary).id }
        schema type: :object, properties: {
                                voiding_record: {
                                  type: :object,
                                  properties: {
                                    recorded_at: { type: :string, format: 'date-time' },
                                    slept_before_and_after: { type: :boolean },
                                    urine_leakage: { type: :boolean },
                                    urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                    urge_strength: { type: :integer },
                                    urine_volume: { type: :integer },
                                    beverage_type: { type: :string,
                                                     enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                    fluid_intake: { type: :integer },
                                    record_type: { type: :string, enum: ['input', 'output'] },
                                    id: { type: :integer }
                                  },
                                  required: ['id', 'recorded_at', 'record_type']
                                }
                              },
               required: ['voiding_record']
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
        let(:id) { create(:voiding_record, voiding_diary: voiding_diary).id }
        schema type: :object, properties: {
                                voiding_record: {
                                  type: :object,
                                  properties: {
                                    recorded_at: { type: :string, format: 'date-time' },
                                    slept_before_and_after: { type: :boolean },
                                    urine_leakage: { type: :boolean },
                                    urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
                                    urge_strength: { type: :integer },
                                    urine_volume: { type: :integer },
                                    beverage_type: { type: :string,
                                                     enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
                                    fluid_intake: { type: :integer },
                                    record_type: { type: :string, enum: ['input', 'output'] },
                                    id: { type: :integer }
                                  },
                                  required: ['id', 'recorded_at', 'record_type']
                                }
                              },
               required: ['voiding_record']
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

    put('update voiding record') do
      tags 'Voiding Records'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :voiding_diary_id, in: :path, type: :integer, description: 'voiding_diary_id'
      parameter name: :voiding_record, in: :body, required: true, schema: {
        type: :object,
        properties: {
          voiding_record: {
            type: :object,
            properties: {
              recorded_at: { type: :string, format: 'date-time' },
              slept_before_and_after: { type: :boolean },
              urine_leakage: { type: :boolean },
              urine_leakage_type: { type: :string, enum: ['stressful', 'urgent'] },
              urge_strength: { type: :integer },
              urine_volume: { type: :integer },
              beverage_type: { type: :string,
                               enum: ['clear_water', 'fizzy_water', 'mineral_water', 'hot_beverage', 'sweet_drink', 'citrus_drink', 'alcohol', 'other'] },
              fluid_intake: { type: :integer }
            }
          }
        },
        required: ['voiding_record']
      }
      let(:id) { create(:voiding_record, voiding_diary: voiding_diary).id }
      let(:voiding_record) do
        {
          voiding_record: {
            urine_volume: 300
          }
        }
      end
      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties:  {
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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
          voiding_record: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['voiding_record']
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

    delete('delete voiding record') do
      tags 'Voiding Records'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :voiding_diary_id, in: :path, type: :integer, description: 'voiding_diary_id'
      let(:id) { create(:voiding_record, voiding_diary: voiding_diary).id }
      response(204, 'successful') do
        authorization_as_admin
        run_test!
      end

      response(204, 'successful') do
        authorization_as_patient
        run_test!
      end

      response(204, 'successful') do
        authorization_as_doctor
        run_test!
      end
    end
  end
end
