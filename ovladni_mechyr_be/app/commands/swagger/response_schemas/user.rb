# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class User
      prepend SimpleCommand

      def call; end

      def timesheets
        {
          pagination: {
            type: :object,
            properties: {
              count: { type: :integer, description: 'Total number of items', example: 100 },
              page: { type: :integer, description: 'Current page number', example: 1 },
              next: { type: :integer, nullable: true, description: 'Next page number, if available', example: 2 },
              pages: { type: :integer, description: 'Total number of pages', example: 5 },
              items: { type: :integer, description: 'Number of items per page', example: 20 }
            }
          },
          timesheets: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                total_time_sec: { type: :integer },
                current_time_sec: { type: :integer },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "User's unique identifier", example: 101 },
                    first_name: { type: :string, description: "User's first name", example: 'Jane' },
                    last_name: { type: :string, description: "User's last name", example: 'Foster' },
                    email: { type: :string, description: "User's email address", example: 'jane.doe@example.com' }
                  },
                  required: ['id', 'first_name', 'email']
                },
                machine: {
                  type: :object,
                  nullable: true,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string }
                  }
                }
              }
            }
          }
        }
      end

      def show
        {
          id: { type: :integer, description: 'Unique identifier for the user', example: 1 },
          first_name: { type: :string, description: 'First name of the user', example: 'John' },
          last_name: { type: :string, description: 'Last name of the user', example: 'Doe' },
          email: { type: :string, format: :email, description: 'Email address of the user', example: 'john.doe@example.com' },
          position: { type: :string, description: 'Position or job title of the user', example: 'Manager' },
          licence_expiration_at: { type: :string, nullable: true, format: 'date-time', description: 'Expiration date of the user\'s licence', example: '2024-12-31T23:59:59Z' },
          employed_from: { type: :string, nullable: true, format: 'date', description: 'Start date of employment', example: '2020-01-01' },
          employed_to: { type: :string, nullable: true, format: 'date', description: 'End date of employment', example: '2024-01-01' },
          roles: {
            type: :array,
            items: {
              type: :string,
              example: 'admin'
            },
            description: 'List of roles assigned to the user'
          },
          current_vacation: {
            type: :object,
            properties: {
              id: { type: :integer },
              start_date: { type: :string, format: 'date-time' },
              end_date: { type: :string, format: 'date-time' }
            }
          },
          documents: {
            type: :array,
            description: 'List of documents attached to the user',
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the document', example: 1001 },
                url: { type: :string, format: :uri, description: 'URL to access the document', example: 'https://example.com/document/1001' },
                filename: { type: :string, description: 'Name of the document file', example: 'resume.pdf' },
                content_type: { type: :string, description: 'MIME type of the document', example: 'application/pdf' }
              }
            }
          },
          services: {
            type: :object,
            description: 'services of the user',
            properties: {
              id: { type: :integer, description: "Service's unique identifier", example: 1 },
              entry_number: { type: :string, description: 'Entry number of the service', example: 'VNJMWFCYQI' },
              engineer_description: { type: :string, description: 'Description provided by the engineer', example: 'Ut odit aperiam. Tempora dolores aut. Id sunt perspiciatis.' },
              engineer_fault_type: { type: :string, description: 'Type of fault reported by the engineer', example: 'middle' },
              repair_place: { type: :string, description: 'Location where the repair is to be carried out', example: 'Apt. 533 49529 Maribel View, Lake Sudieland, HI 08760' },
              fuel_state: { type: :string, description: 'State of the fuel', example: 'E-85/Gasoline' },
              handover_place: { type: :string, description: 'Place where the service is handed over', example: '64849 Timmy Underpass, Cherrytown, KS 59636' },
              handover_date: { type: :string, format: :date_time, description: 'Date and time when the service is handed over', example: '2024-06-20T08:02:49.000Z' },
              estimated_completion: { type: :string, format: :date_time, description: 'Estimated completion date and time', example: '2024-06-24T23:21:29.000Z' },
              reporter_description: { type: :string, description: 'Description provided by the reporter',
                                      example: 'Aut voluptatibus nulla. Non repellendus ut. Non temporibus repudiandae.' },
              reporting_date: { type: :string, format: :date_time, description: 'Date and time when the service was reported', example: '2024-06-07T10:13:01.000Z' },
              reporter_fault_type: { type: :string, description: 'Type of fault reported by the reporter', example: 'maintenance_plan' },
              state: { type: :string, description: 'Current state of the service', example: 'waiting_repair' },
              worker_description: { type: :string, description: 'Description provided by the worker',
                                    example: 'Perspiciatis ut similique. Laborum nostrum nobis. Adipisci expedita et.' },
              created_at: { type: :string, format: :date_time, description: 'Date and time when the service was created', example: '2024-06-13T07:57:49.204Z' },
              updated_at: { type: :string, format: :date_time, description: 'Date and time when the service was last updated', example: '2024-06-13T07:57:49.204Z' },
              reporter: {
                type: :object,
                properties: {
                  id: { type: :integer, description: 'Service identifier of the reporter', example: 1 },
                  first_name: { type: :string, description: 'First name of the reporter', example: 'Jane' },
                  last_name: { type: :string, description: 'Last name of the reporter', example: 'Doe' },
                  position: { type: :string, description: 'Position of the reporter', example: 'Technician' }
                }
              },
              machine: {
                type: :object,
                properties: {
                  id: { type: :integer, description: "Machine's unique identifier", example: 1 },
                  name: { type: :string, description: 'Name of the machine', example: 'Excavator' },
                  registration: { type: :string, description: 'Registration number of the machine', example: 'EX12345' },
                  locomotive: { type: :boolean, description: 'Indicates if the machine is a locomotive', example: false },
                  motorcycle_hours: { type: :integer, description: 'Motorcycle hours', example: 60 },
                  next_service_interval: { type: :integer, description: 'Next service interval', example: 1 },
                  validity_of_licence: { type: :string, format: :date, description: 'Validity of the licence', example: '2024-09-17' },
                  validity_of_exams: { type: :string, format: :date, description: 'Validity of the licence', example: '2024-09-17' }
                }
              }
            }
          }
        }
      end

      def index
        {
          pagination: {
            type: :object,
            properties: {
              count: { type: :integer, description: 'Total number of items', example: 100 },
              page: { type: :integer, description: 'Current page number', example: 1 },
              next: { type: :integer, nullable: true, description: 'Next page number, if available', example: 2 },
              pages: { type: :integer, description: 'Total number of pages', example: 5 },
              items: { type: :integer, description: 'Number of items per page', example: 20 }
            }
          },
          users: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the user', example: 1 },
                first_name: { type: :string, description: 'First name of the user', example: 'John' },
                last_name: { type: :string, description: 'Last name of the user', example: 'Doe' },
                position: { type: :string, description: 'Position or job title of the user', example: 'Manager' },
                licence_expiration_at: { type: :string, nullable: true, format: 'date-time',
                                         description: 'Expiration date of the user\'s licence', example: '2024-12-31T23:59:59Z' }
              }
            }
          }
        }
      end

      def current_timesheet
        {
          id: { type: :integer, description: "Timesheet's unique identifier", example: 1 },
          created_at: { type: :string, format: :date_time, description: 'Date and time when the timesheet was created', example: '2024-08-01T12:34:56Z' },
          total_time_sec: { type: :integer, description: 'Total time in seconds', example: 3600 },
          current_time_sec: { type: :integer, description: 'Current time in seconds', example: 1800 },
          user: {
            type: :object,
            description: 'Details of the user associated with the timesheet',
            properties: {
              id: { type: :integer, description: "User's unique identifier", example: 101 }
            }
          },
          service: {
            type: :object,
            description: 'Details of the service associated with the timesheet',
            properties: {
              id: { type: :integer, description: "Service's unique identifier", example: 202 },
              machine: {
                type: :object,
                description: 'Details of the machine associated with the service',
                properties: {
                  id: { type: :integer, description: "Machine's unique identifier", example: 303 },
                  name: { type: :string, description: 'Name of the machine', example: 'Excavator' }
                }
              }
            }
          }
        }
      end
    end
  end
end
