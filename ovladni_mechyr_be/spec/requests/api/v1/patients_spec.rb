# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/patients', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let!(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/patients' do
    get('list patients') do
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

      parameter name: :patient_id, in: :query, schema: {
        type: :integer,
        description: 'Filter by patient_id',
        example: '1'
      }

      parameter name: :email, in: :query, schema: {
        type: :string,
        description: 'Filter by patient email',
        example: 'email@email.com'
      }

      parameter name: :sort_by, in: :query, schema: {
        type: :string, enum: ['next_appointment', 'email', 'patient_id', 'appointment_initial', 'appointment_second', 'appointment_first'],
        description: 'Sorting',
        example: 'patient_id'
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
      let(:patient_id) { '' }
      let(:email) { '' }

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
                                patients: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      patient_id: { type: :integer },
                                      patient_public_id: { type: :string },
                                      email: { type: :string },
                                      next_appointment: { type: :string, format: 'date-time', nullable: true },
                                      appointment_initial: { type: :boolean, nullable: true },
                                      appointment_initial_id: { type: :integer, nullable: true },
                                      appointment_first: { type: :boolean, nullable: true },
                                      appointment_first_id: { type: :integer, nullable: true },
                                      appointment_second: { type: :boolean, nullable: true },
                                      appointment_second_id: { type: :integer, nullable: true }
                                    },
                                    required: ['patient_id', 'patient_public_id', 'id', 'email',
                                               'appointment_initial', 'appointment_first', 'appointment_second',
                                               'appointment_initial_id', 'appointment_first_id', 'appointment_second_id']
                                  }
                                }
                              },
               required: ['pagination', 'patients']
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
                                patients: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      patient_id: { type: :integer },
                                      patient_public_id: { type: :string },
                                      email: { type: :string },
                                      next_appointment: { type: :string, format: 'date-time', nullable: true },
                                      appointment_initial: { type: :boolean, nullable: true },
                                      appointment_first: { type: :boolean, nullable: true },
                                      appointment_second: { type: :boolean, nullable: true }
                                    },
                                    required: ['patient_id', 'patient_public_id', 'id', 'email', 'appointment_initial', 'appointment_first', 'appointment_second']
                                  }
                                }
                              },
               required: ['pagination', 'patients']
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
    end
  end

  path '/api/v1/patients/list_to_be_approved' do
    get('list patients') do
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

      parameter name: :sort_by, in: :query, schema: {
        type: :string, enum: ['email', 'patient_id'],
        description: 'Sorting',
        example: 'patient_id'
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
                                patients: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      patient_id: { type: :integer },
                                      patient_public_id: { type: :string },
                                      email: { type: :string }
                                    },
                                    required: ['id', 'email', 'patient_id', 'patient_public_id']
                                  }
                                }
                              },
               required: ['pagination', 'patients']
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
                                patients: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      patient_id: { type: :integer },
                                      patient_public_id: { type: :string },
                                      email: { type: :string }
                                    },
                                    required: ['id', 'email', 'patient_id', 'patient_public_id']
                                  }
                                }
                              },
               required: ['pagination', 'patients']
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
    end
  end

  path '/api/v1/patients/request_assignment' do
    put('request_assignment patient') do
      tags 'Patient and doctor'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      response(204, 'successful') do
        authorization_as_patient
        let!(:other_patient) { create(:patient, user: user_patient, doctor: nil, agreed_to_share_info: true) }
        let!(:id) { create(:patient, approved: false, user_id: user_patient.id).id }

        let!(:oab_form) { create(:oab_form, patient_id: other_patient.id, completed: true) }
        let!(:ipss_form) { create(:ipss_form, patient_id: other_patient.id, completed: true) }
        let!(:iciq_form) { create(:iciq_form, patient_id: other_patient.id, completed: true) }
        let!(:anamnestic_form) { create(:anamnestic_form, patient_id: other_patient.id, completed: true) }
        let!(:voiding_diary) { create(:voiding_diary, patient_id: other_patient.id, completed: true) }

        parameter name: :patient, in: :body, required: true, schema: {
          type: :object,
          properties: {
            patient: {
              type: :object,
              properties: {
                agreed_to_share_info: { type: :boolean },
                doctor_id: { type: :integer }
              },
              required: ['agreed_to_share_info', 'doctor_id']
            },
            email: {
              type: :object,
              properties: {
                custom_message: { type: :string }
              },
              required: ['custom_message']
            }
          },
          required: ['patient', 'email']
        }

        let(:patient) do
          {
            patient: {
              agreed_to_share_info: true,
              doctor_id: user_doctor.id # Use the doctor's ID here as well
            },
            email: {
              phone_number: '+15551234567',
              custom_message: 'čus',
              preferred_contact: 'email'
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

  path '/api/v1/patients/approve/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'patients id'

    put('approve patient') do
      tags 'Patient and doctor'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      response(204, 'successful') do
        authorization_as_doctor
        let(:user) { create(:user) }
        let(:id) { create(:patient, approved: false, user_id: user.id).id }
        let(:patient) { { approved: true } }

        parameter name: :patient, in: :body, required: true, schema: {
          type: :object,
          properties: {
            patient: {
              type: :object,
              properties: {
                next_appointment: { type: :string, format: 'date-time' }
              },
              required: ['next_appointment']
            }
          },
          required: ['patient']
        }
        run_test!
      end

      response(404, 'not found') do
        authorization_as_admin
        let(:id) { create(:patient).id }
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        let(:id) { create(:patient).id }
        run_test!
      end
    end
  end

  path '/api/v1/patients/reject/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'patients id'

    put('reject patient') do
      tags 'Patient and doctor'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]

      response(204, 'no_content') do
        authorization_as_admin
        let(:user) { create(:user) }
        let(:doctor) { create(:doctor) }
        let(:id) { create(:patient, approved: true, user_id: user.id, doctor_id: doctor.id).id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
          }
        end
        run_test!
      end

      response(204, 'no_content') do
        authorization_as_doctor
        let(:user) { create(:user) }
        let(:doctor) { create(:doctor) }
        let(:id) { create(:patient, approved: true, user_id: user.id, doctor_id: doctor.id).id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        let(:id) { create(:patient).id }
        run_test!
      end
    end
  end
end
