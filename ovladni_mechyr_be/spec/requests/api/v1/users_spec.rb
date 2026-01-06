# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let!(:doctor) { create(:doctor, user: user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, doctor: doctor) }

  path '/api/v1/users' do
    get('list users') do
      tags 'Users'
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

      let(:items_per_page) { 20 }
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
                                  required: ['count', 'page', 'next', 'pages', 'items']
                                },
                                users: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      email: { type: :string },
                                      roles: {
                                        type: :array,
                                        items: { type: :string, enum: ['patient', 'doctor', 'admin'] },
                                        description: 'List of roles assigned to the user'
                                      }
                                    },
                                    required: ['id', 'email', 'roles']
                                  }
                                }
                              },
               required: ['pagination', 'users']

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
  end

  path '/api/v1/users/find_by_token/{invitation_token}' do
    parameter name: 'invitation_token', in: :path, type: :string, description: 'invitation_token'
    get('show invited user') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object, properties:  {
          user: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              email: { type: :string, example: 'doctor@uzis.com' }
            },
            required: ['id', 'email']
          }
        }, required: ['user']
        User.where(email: 'inviter@h2pime.com').destroy_all
        inviter = FactoryBot.create(:user, email: 'inviter@h2pime.com')
        user = User.invite!({ email: "invite#{rand(10)}@testh2.com" }, inviter)
        let(:invitation_token) { user.raw_invitation_token }
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

  path '/api/v1/users/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:id) { user_admin.id }
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },

                     email: {
                       type: :string
                     },
                     roles: {
                       type: :array,
                       items: {
                         type: :string, enum: ['patient', 'doctor', 'admin'],
                         example: 'patient'
                       },
                       description: 'List of roles assigned to the user'
                     },
                     full_name: { type: :string, nullable: true },
                     gender: { type: :string, enum: ['male', 'female', 'other'], nullable: true },
                     other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'], nullable: true },
                     doctor_id: { type: :integer, nullable: true },
                     approved: { type: :boolean, nullable: true },
                     can_be_assigned: { type: :boolean, nullable: true },
                     workplace: { type: :string, nullable: true },
                     contact_email: { type: :string, nullable: true },
                     contact_phone: { type: :string, nullable: true },
                     city: { type: :string, nullable: true },
                     working_hours: { type: :string, nullable: true },
                     postal_code: { type: :integer, nullable: true },
                     street_and_number: { type: :string, nullable: true },
                     full_capacity: { type: :boolean, nullable: true },
                     latitude: { type: :number, nullable: true },
                     longitude: { type: :number, nullable: true },
                     web: { type: :string, nullable: true },
                     is_contactable: { type: :boolean, nullable: true },
                     entry_form_id: { type: :integer, nullable: true },
                     oab_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     ipss_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     iciq_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     anamnestic_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     appointment_initial_id: { type: :integer, nullable: true },
                     appointment_first_id: { type: :integer, nullable: true },
                     appointment_second_id: { type: :integer, nullable: true },
                     voiding_diary_ids: { type: :array, items: { type: :integer }, nullable: true },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     contact_status: { type: :string, enum: ['allowed', 'forbidden', 'contacted'] },
                     next_appointment: { type: :string, format: 'date-time', nullable: true },
                     allowed_to_create_second_appointment: { type: :boolean },
                     doctor_name: { type: :string }
                   },
                   required: ['id', 'email', 'roles']

                 }
               },
               required: ['user']

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
        let(:another_user) { FactoryBot.create(:user) }
        let(:id) { another_user.id }
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },

                     email: {
                       type: :string
                     },
                     roles: {
                       type: :array,
                       items: {
                         type: :string, enum: ['patient', 'doctor', 'admin'],
                         example: 'patient'
                       },
                       description: 'List of roles assigned to the user'
                     },
                     full_name: { type: :string, nullable: true },
                     gender: { type: :string, enum: ['male', 'female', 'other'], nullable: true },
                     other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'], nullable: true },
                     doctor_id: { type: :integer, nullable: true },
                     approved: { type: :boolean, nullable: true },
                     can_be_assigned: { type: :boolean, nullable: true },
                     workplace: { type: :string, nullable: true },
                     contact_email: { type: :string, nullable: true },
                     contact_phone: { type: :string, nullable: true },
                     city: { type: :string, nullable: true },
                     working_hours: { type: :string, nullable: true },
                     postal_code: { type: :integer, nullable: true },
                     street_and_number: { type: :string, nullable: true },
                     full_capacity: { type: :boolean, nullable: true },
                     latitude: { type: :number, nullable: true },
                     longitude: { type: :number, nullable: true },
                     web: { type: :string, nullable: true },
                     is_contactable: { type: :boolean, nullable: true },
                     entry_form_id: { type: :integer, nullable: true },
                     oab_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     ipss_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     iciq_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     anamnestic_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     appointment_initial_id: { type: :integer, nullable: true },
                     appointment_first_id: { type: :integer, nullable: true },
                     appointment_second_id: { type: :integer, nullable: true },
                     voiding_diary_ids: { type: :array, items: { type: :integer }, nullable: true },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     contact_status: { type: :string, enum: ['allowed', 'forbidden', 'contacted'] },
                     next_appointment: { type: :string, format: 'date-time', nullable: true },
                     allowed_to_create_second_appointment: { type: :boolean },
                     doctor_name: { type: :string }
                   },
                   required: ['id', 'email', 'roles']

                 }
               },
               required: ['user']

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
        let(:id) { user_patient.id }
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },

                     email: {
                       type: :string
                     },
                     roles: {
                       type: :array,
                       items: {
                         type: :string, enum: ['patient', 'doctor', 'admin'],
                         example: 'patient'
                       },
                       description: 'List of roles assigned to the user'
                     },
                     full_name: { type: :string, nullable: true },
                     gender: { type: :string, enum: ['male', 'female', 'other'], nullable: true },
                     other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'], nullable: true },
                     doctor_id: { type: :integer, nullable: true },
                     approved: { type: :boolean, nullable: true },
                     can_be_assigned: { type: :boolean, nullable: true },
                     workplace: { type: :string, nullable: true },
                     contact_email: { type: :string, nullable: true },
                     contact_phone: { type: :string, nullable: true },
                     city: { type: :string, nullable: true },
                     working_hours: { type: :string, nullable: true },
                     postal_code: { type: :integer, nullable: true },
                     street_and_number: { type: :string, nullable: true },
                     full_capacity: { type: :boolean, nullable: true },
                     latitude: { type: :number, nullable: true },
                     longitude: { type: :number, nullable: true },
                     web: { type: :string, nullable: true },
                     is_contactable: { type: :boolean, nullable: true },
                     entry_form_id: { type: :integer, nullable: true },
                     oab_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     ipss_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     iciq_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     anamnestic_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     appointment_initial_id: { type: :integer, nullable: true },
                     appointment_first_id: { type: :integer, nullable: true },
                     appointment_second_id: { type: :integer, nullable: true },
                     voiding_diary_ids: { type: :array, items: { type: :integer }, nullable: true },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     contact_status: { type: :string, enum: ['allowed', 'forbidden', 'contacted'] },
                     next_appointment: { type: :string, format: 'date-time', nullable: true },
                     allowed_to_create_second_appointment: { type: :boolean },
                     doctor_name: { type: :string }
                   },
                   required: ['id', 'email', 'roles']

                 }
               },
               required: ['user']

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
        let(:another_user) { FactoryBot.create(:user) }
        let(:id) { another_user.id }
        run_test!
      end

      response(200, 'successful') do
        authorization_as_doctor
        let(:id) { user_doctor.id }
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },

                     email: {
                       type: :string
                     },
                     roles: {
                       type: :array,
                       items: {
                         type: :string, enum: ['patient', 'doctor', 'admin'],
                         example: 'patient'
                       },
                       description: 'List of roles assigned to the user'
                     },
                     full_name: { type: :string, nullable: true },
                     gender: { type: :string, enum: ['male', 'female', 'other'], nullable: true },
                     other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'], nullable: true },
                     doctor_id: { type: :integer, nullable: true },
                     approved: { type: :boolean, nullable: true },
                     can_be_assigned: { type: :boolean, nullable: true },
                     workplace: { type: :string, nullable: true },
                     contact_email: { type: :string, nullable: true },
                     contact_phone: { type: :string, nullable: true },
                     city: { type: :string, nullable: true },
                     working_hours: { type: :string, nullable: true },
                     postal_code: { type: :integer, nullable: true },
                     street_and_number: { type: :string, nullable: true },
                     full_capacity: { type: :boolean, nullable: true },
                     latitude: { type: :number, nullable: true },
                     longitude: { type: :number, nullable: true },
                     web: { type: :string, nullable: true },
                     is_contactable: { type: :boolean, nullable: true },
                     entry_form_id: { type: :integer, nullable: true },
                     oab_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     ipss_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     iciq_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     anamnestic_form_ids: { type: :array, items: { type: :integer }, nullable: true },
                     appointment_initial_id: { type: :integer, nullable: true },
                     appointment_first_id: { type: :integer, nullable: true },
                     appointment_second_id: { type: :integer, nullable: true },
                     patient_public_id: { type: :string },
                     patient_id: { type: :integer },
                     contact_status: { type: :string, enum: ['allowed', 'forbidden', 'contacted'] },
                     next_appointment: { type: :string, format: 'date-time' },
                     allowed_to_create_second_appointment: { type: :boolean }
                   },
                   required: ['id', 'email', 'roles']
                 }
               },
               required: ['user']

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

    patch('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      response(200, 'successful') do
        authorization_as_admin
        let(:id) { user_admin.id }
        let(:user) { { full_name: 'Updated Name' } }

        parameter name: :user, in: :body, required: true, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: {
                  type: :integer
                },

                email: {
                  type: :string
                },
                roles: {
                  type: :array,
                  items: {
                    type: :string, enum: ['patient', 'doctor', 'admin'],
                    example: 'patient'
                  },
                  description: 'List of roles assigned to the user'
                },
                patient_attributes: {
                  type: :object,
                  properties: {
                    full_name: { type: :string },
                    user_id: { type: :integer },
                    gender: { type: :string, enum: ['male', 'female', 'other'] },
                    other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'] },
                    next_appointment: { type: :string, format: 'date-time' }
                  },
                  required: ['full_name', 'user_id', 'gender', 'next_appointment']
                },
                doctor_attributes: {
                  type: :object,
                  properties: {
                    user_id: { type: :integer },
                    full_name: { type: :string },
                    workplace: { type: :string },
                    contact_email: { type: :string },
                    contact_phone: { type: :string },
                    city: { type: :string },
                    working_hours: { type: :string },
                    postal_code: { type: :integer },
                    street_and_number: { type: :string },
                    full_capacity: { type: :string },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float },
                    web: { type: :string, nullable: true }
                  },
                  required: ['user_id',
                             'full_name',
                             'workplace',
                             'contact_email',
                             'contact_phone',
                             'city',
                             'working_hours',
                             'postal_code',
                             'street_and_number',
                             'full_capacity',
                             'latitude',
                             'longitude',
                             'web']
                }
              },
              required: ['id', 'email', 'roles']
            }
          },
          required: ['user']
        }
        schema type: :object, properties:  {
          user: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            }
          }
        }, required: ['user']

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
        let(:another_user) { FactoryBot.create(:user) }
        let(:id) { another_user.id }
        let(:user) { { full_name: 'Updated Name' } }

        parameter name: :user, in: :body, required: true, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: {
                  type: :integer
                },

                email: {
                  type: :string
                },
                roles: {
                  type: :array,
                  items: {
                    type: :string, enum: ['patient', 'doctor', 'admin'],
                    example: 'patient'
                  },
                  description: 'List of roles assigned to the user'
                },
                patient_attributes: {
                  type: :object,
                  properties: {
                    full_name: { type: :string },
                    user_id: { type: :integer },
                    gender: { type: :string, enum: ['male', 'female', 'other'] },
                    other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'] },
                    next_appointment: { type: :string, format: 'date-time' }
                  },
                  required: ['full_name', 'user_id', 'gender', 'next_appointment']
                },
                doctor_attributes: {
                  type: :object,
                  properties: {
                    user_id: { type: :integer },
                    full_name: { type: :string },
                    workplace: { type: :string },
                    contact_email: { type: :string },
                    contact_phone: { type: :string },
                    city: { type: :string },
                    working_hours: { type: :string },
                    postal_code: { type: :integer },
                    street_and_number: { type: :string },
                    full_capacity: { type: :string },
                    web: { type: :string, nullable: true },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float }
                  },
                  required: ['user_id',
                             'full_name',
                             'workplace',
                             'contact_email',
                             'contact_phone',
                             'city',
                             'working_hours',
                             'postal_code',
                             'street_and_number',
                             'full_capacity',
                             'latitude',
                             'longitude',
                             'web']
                }
              },
              required: ['id', 'email', 'roles']
            }
          },
          required: ['user']
        }
        schema type: :object, properties:  {
          user: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            }
          }
        }, required: ['user']

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
        let(:id) { user_patient.id }
        let(:user) { { full_name: 'Updated Name' } }

        parameter name: :user, in: :body, required: true, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: {
                  type: :integer
                },

                email: {
                  type: :string
                },
                roles: {
                  type: :array,
                  items: {
                    type: :string, enum: ['patient', 'doctor', 'admin'],
                    example: 'patient'
                  },
                  description: 'List of roles assigned to the user'
                },
                patient_attributes: {
                  type: :object,
                  properties: {
                    full_name: { type: :string },
                    user_id: { type: :integer },
                    gender: { type: :string, enum: ['male', 'female', 'other'] },
                    other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'] }
                  },
                  required: ['full_name', 'user_id', 'gender']
                },
                doctor_attributes: {
                  type: :object,
                  properties: {
                    user_id: { type: :integer },
                    full_name: { type: :string },
                    workplace: { type: :string },
                    contact_email: { type: :string },
                    contact_phone: { type: :string },
                    city: { type: :string },
                    working_hours: { type: :string },
                    postal_code: { type: :integer },
                    street_and_number: { type: :string },
                    full_capacity: { type: :string },
                    web: { type: :string, nullable: true },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float }
                  },
                  required: ['user_id',
                             'full_name',
                             'workplace',
                             'contact_email',
                             'contact_phone',
                             'city',
                             'working_hours',
                             'postal_code',
                             'street_and_number',
                             'full_capacity',
                             'latitude',
                             'longitude',
                             'web']
                }
              },
              required: ['id', 'email', 'roles']
            }
          },
          required: ['user']
        }
        schema type: :object, properties:  {
          user: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            }
          }
        }, required: ['user']

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
        let(:another_user) { FactoryBot.create(:user) }
        let(:id) { another_user.id }
        let(:user) { { full_name: 'Updated Name' } }
        run_test!
      end

      response(200, 'successful') do
        authorization_as_doctor
        let(:id) { user_doctor.id }
        let(:user) { { full_name: 'Updated Name' } }

        parameter name: :user, in: :body, required: true, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: {
                  type: :integer
                },

                email: {
                  type: :string
                },
                roles: {
                  type: :array,
                  items: {
                    type: :string, enum: ['patient', 'doctor', 'admin'],
                    example: 'patient'
                  },
                  description: 'List of roles assigned to the user'
                },
                patient_attributes: {
                  type: :object,
                  properties: {
                    full_name: { type: :string },
                    user_id: { type: :integer },
                    gender: { type: :string, enum: ['male', 'female', 'other'] },
                    other_gender: { type: :string, enum: ['with_prostate', 'without_prostate'] }
                  },
                  required: ['full_name', 'user_id', 'gender']
                },
                doctor_attributes: {
                  type: :object,
                  properties: {
                    user_id: { type: :integer },
                    full_name: { type: :string },
                    workplace: { type: :string },
                    contact_email: { type: :string },
                    contact_phone: { type: :string },
                    city: { type: :string },
                    working_hours: { type: :string },
                    postal_code: { type: :integer },
                    street_and_number: { type: :string },
                    full_capacity: { type: :string },
                    web: { type: :string, nullable: true },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float }
                  },
                  required: ['user_id',
                             'full_name',
                             'workplace',
                             'contact_email',
                             'contact_phone',
                             'city',
                             'working_hours',
                             'postal_code',
                             'street_and_number',
                             'full_capacity',
                             'latitude',
                             'longitude',
                             'web']
                }
              },
              required: ['id', 'email', 'roles']
            }
          },
          required: ['user']
        }
        schema type: :object, properties:  {
          user: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            }
          }
        }, required: ['user']

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
        let(:another_user) { FactoryBot.create(:user) }
        let(:id) { another_user.id }
        let(:user) { { full_name: 'Updated Name' } }
        run_test!
      end
    end

    delete('delete user') do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:user).id }
      response(204, 'no content') do
        authorization_as_admin

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {}
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
  end
  path '/api/v1/users/{id}/forms' do
    parameter name: 'id', in: :path, type: :integer, description: 'user_id'

    get("show user's forms") do
      tags 'Users'
      produces 'application/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:id) { user_patient.id }
        let!(:oab_form) { create(:oab_form, patient_id: patient.id) }
        let!(:ipss_form) { create(:ipss_form, patient_id: patient.id) }
        let!(:iciq_form) { create(:iciq_form, patient_id: patient.id) }
        let!(:anamnestic_form) { create(:anamnestic_form, patient_id: patient.id) }

        schema type: :object, properties: {
                                forms: {
                                  type: :object,
                                  properties: {
                                    oab_forms: {
                                      type: :array,
                                      items: {
                                        type: :object,
                                        properties: {
                                          id: { type: :integer },
                                          completion_timestamp: { type: :string, format: 'date-time' },
                                          total_score: { type: :integer }
                                        },
                                        required: %i[id completion_timestamp total_score]
                                      }
                                    },
                                    ipss_forms: {
                                      type: :array,
                                      items: {
                                        type: :object,
                                        properties: {
                                          id: { type: :integer },
                                          completion_timestamp: { type: :string, format: 'date-time' },
                                          total_score: { type: :integer }
                                        },
                                        required: %i[id completion_timestamp total_score]
                                      }
                                    },
                                    iciq_forms: {
                                      type: :array,
                                      items: {
                                        type: :object,
                                        properties: {
                                          id: { type: :integer },
                                          completion_timestamp: { type: :string, format: 'date-time' },
                                          total_score: { type: :integer }
                                        },
                                        required: %i[id completion_timestamp total_score]
                                      }
                                    },
                                    anamnestic_forms: {
                                      type: :array,
                                      items: {
                                        type: :object,
                                        properties: {
                                          id: { type: :integer },
                                          completion_timestamp: { type: :string, format: 'date-time' },
                                          total_score: { type: :integer, nullable: true }
                                        },
                                        required: %i[id completion_timestamp]
                                      }
                                    }
                                  },
                                  required: %i[anamnestic_forms iciq_forms ipss_forms oab_forms]
                                }
                              },
               required: [:forms]

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

  path '/api/v1/users/{id}/diaries' do
    parameter name: 'id', in: :path, type: :integer, description: 'user_id'

    get("show user's diaries") do
      tags 'Users'
      produces 'application/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:id) { user_patient.id }
        let!(:voiding_diary) { create(:voiding_diary, patient_id: patient.id) }

        schema type: :object, properties: {
                                voiding_diaries: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      id: { type: :integer },
                                      diary_start_date: { type: :string, format: 'date' }
                                    },
                                    required: ['id', 'diary_start_date']
                                  }
                                }
                              },
               required: ['voiding_diaries']
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
end
