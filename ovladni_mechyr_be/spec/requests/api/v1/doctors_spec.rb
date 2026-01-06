# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/doctors/available_doctors', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let!(:doctor) { create(:doctor, user: user_doctor) }

  path '/api/v1/doctors/available_doctors' do
    get('list available doctors') do
      tags 'Patient and doctor'
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

      parameter name: :city, in: :query, schema: {
        type: :string,
        description: 'Filter by city',
        example: 'Praha'
      }

      parameter name: :full_name, in: :query, schema: {
        type: :string,
        description: 'Filter by full name',
        example: 'Karel'
      }

      parameter name: :sort_by, in: :query, schema: {
        type: :string, enum: ['full_name', 'city', 'street_and_number'],
        description: 'Sorting',
        example: 'full_name'
      }

      parameter name: :direction, in: :query, schema: {
        type: :string, enum: ['asc', 'desc'],
        description: 'Direction of sorting',
        example: 'asc'
      }

      let(:sort_by) { '' }
      let(:direction) { '' }
      let(:items_per_page) { 30 }
      let(:page_param) { 1 }
      let(:city) { '' }
      let(:full_name) { '' }

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
                                doctors: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      full_name: { type: :string, nullable: true },
                                      workplace: { type: :string, nullable: true },
                                      contact_email: { type: :string, nullable: true },
                                      contact_phone: { type: :string, nullable: true },
                                      postal_code: { type: :integer, nullable: true },
                                      city: { type: :string, nullable: true },
                                      street_and_number: { type: :string, nullable: true },
                                      latitude: { type: :number, nullable: true },
                                      longitude: { type: :number, nullable: true },
                                      id: { type: :integer },
                                      web: { type: :string, nullable: true }
                                    },
                                    required: ['id', 'full_name', 'workplace', 'contact_email', 'contact_phone', 'postal_code',
                                               'city', 'street_and_number', 'latitude', 'longitude', 'web']
                                  }
                                }
                              },
               required: ['pagination', 'doctors']
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
                                doctors: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      full_name: { type: :string, nullable: true },
                                      workplace: { type: :string, nullable: true },
                                      contact_email: { type: :string, nullable: true },
                                      contact_phone: { type: :string, nullable: true },
                                      postal_code: { type: :integer, nullable: true },
                                      city: { type: :string, nullable: true },
                                      street_and_number: { type: :string, nullable: true },
                                      latitude: { type: :number, nullable: true },
                                      longitude: { type: :number, nullable: true },
                                      id: { type: :integer },
                                      web: { type: :string, nullable: true }
                                    },
                                    required: ['id', 'full_name', 'workplace', 'contact_email', 'contact_phone', 'postal_code',
                                               'city', 'street_and_number', 'latitude', 'longitude', 'web']
                                  }
                                }
                              },
               required: ['pagination', 'doctors']
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
  end

  path '/api/v1/doctors/update_full_capacity' do
    put('update full capacity') do
      tags 'Patient and doctor'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :doctor, in: :body, required: true, schema: {
        type: :object,
        properties: {
          doctor: {
            type: :object,
            properties: {
              full_capacity: { type: :boolean }
            },
            required: ['full_capacity']
          }
        },
        required: ['doctor']
      }
      response(204, 'no content') do
        authorization_as_doctor
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        run_test!
      end

      response(404, 'not found') do
        authorization_as_admin
        run_test!
      end
    end
  end
end
