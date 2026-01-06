# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class UserServiceTimesheet
      prepend SimpleCommand

      def call; end

      def index
        {
          pagination: {
            type: :object,
            properties: {
              count: { type: :integer, description: 'Total number of items' },
              page: { type: :integer, description: 'Current page number' },
              next: { type: :integer, description: 'Number of the next page' },
              pages: { type: :integer, description: 'Total number of pages' },
              items: { type: :integer, description: 'Number of items per page' }
            },
            required: ['count', 'page', 'next', 'pages', 'items']
          },
          timesheets: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: "Timesheet's unique identifier", example: 1 },
                start_date: { type: :string, format: :date, description: 'Start date of the timesheet', example: '2023-09-01' },
                end_date: { type: :string, format: :date, description: 'End date of the timesheet', example: '2023-09-30' },
                total_time_sec: { type: :integer, description: 'Total time recorded in seconds', example: 3600 },
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
                service: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Service's unique identifier", example: 201 }
                  },
                  required: ['id']
                }
              },
              required: ['id', 'start_date', 'end_date', 'total_time_sec', 'user', 'service']
            }
          }
        }
      end
    end
  end
end
