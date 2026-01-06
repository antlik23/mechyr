# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Vacation
      prepend SimpleCommand

      def call; end

      def show
        {
          vacation: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Vacation's unique identifier", example: 1 },
              start_date: { type: :string, format: :date, description: 'Start date of the vacation', example: '2024-01-01' },
              end_date: { type: :string, format: :date, description: 'End date of the vacation', example: '2024-01-10' },
              representative: {
                type: :object,
                description: 'Representative details',
                properties: {
                  id: { type: :integer, description: "Representative's unique identifier", example: 1 },
                  first_name: { type: :string, description: 'First name of the representative', example: 'Jane' },
                  last_name: { type: :string, description: 'Last name of the representative', example: 'Doe' },
                  email: { type: :string, description: 'Email address of the representative', example: 'jane.doe@example.com' },
                  position: { type: :string, description: 'Position of the representative', example: 'Manager' },
                  licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the representative', example: '2024-12-31' },
                  employed_from: { type: :string, format: :date, description: 'Employment start date of the representative', example: '2020-01-01' },
                  employed_to: { type: :string, format: :date, description: 'Employment end date of the representative', example: '2023-01-01' },
                  roles: { type: :array, items: { type: :string, description: 'Roles of the representative', example: 'Manager' } }
                }
              },
              creator: {
                type: :object,
                description: 'Creator details',
                properties: {
                  id: { type: :integer, description: "Creator's unique identifier", example: 2 },
                  first_name: { type: :string, description: 'First name of the creator', example: 'John' },
                  last_name: { type: :string, description: 'Last name of the creator', example: 'Smith' },
                  email: { type: :string, description: 'Email address of the creator', example: 'john.smith@example.com' },
                  position: { type: :string, description: 'Position of the creator', example: 'Admin' },
                  licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the creator', example: '2024-12-31' },
                  employed_from: { type: :string, format: :date, description: 'Employment start date of the creator', example: '2020-01-01' },
                  employed_to: { type: :string, format: :date, description: 'Employment end date of the creator', example: '2023-01-01' },
                  roles: { type: :array, items: { type: :string, description: 'Roles of the creator', example: 'Admin' } }
                }
              },
              vacation_for_user: {
                type: :object,
                description: 'Creator details',
                properties: {
                  id: { type: :integer, description: "Creator's unique identifier", example: 2 },
                  first_name: { type: :string, description: 'First name of the creator', example: 'John' },
                  last_name: { type: :string, description: 'Last name of the creator', example: 'Smith' },
                  email: { type: :string, description: 'Email address of the creator', example: 'john.smith@example.com' },
                  position: { type: :string, description: 'Position of the creator', example: 'Admin' },
                  licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the creator', example: '2024-12-31' },
                  employed_from: { type: :string, format: :date, description: 'Employment start date of the creator', example: '2020-01-01' },
                  employed_to: { type: :string, format: :date, description: 'Employment end date of the creator', example: '2023-01-01' },
                  roles: { type: :array, items: { type: :string, description: 'Roles of the creator', example: 'Admin' } }
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
              count: { type: :integer, description: 'Total number of items', example: 50 },
              page: { type: :integer, description: 'Current page number', example: 1 },
              next: { type: :integer, description: 'Next page number, if applicable', example: 2 },
              pages: { type: :integer, description: 'Total number of pages', example: 5 },
              items: { type: :integer, description: 'Number of items per page', example: 10 }
            }
          },
          vacations: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: "Vacation's unique identifier", example: 1 },
                start_date: { type: :string, format: :date, description: 'Start date of the vacation', example: '2024-01-01' },
                end_date: { type: :string, format: :date, description: 'End date of the vacation', example: '2024-01-10' },
                representative: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Representative's unique identifier", example: 1 },
                    first_name: { type: :string, description: 'First name of the representative', example: 'Jane' },
                    last_name: { type: :string, description: 'Last name of the representative', example: 'Doe' },
                    email: { type: :string, description: 'Email address of the representative', example: 'jane.doe@example.com' },
                    position: { type: :string, description: 'Position of the representative', example: 'Manager' },
                    licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the representative', example: '2024-12-31' },
                    employed_from: { type: :string, format: :date, description: 'Employment start date of the representative', example: '2020-01-01' },
                    employed_to: { type: :string, format: :date, description: 'Employment end date of the representative', example: '2023-01-01' },
                    roles: { type: :array, items: { type: :string, description: 'Roles of the representative', example: 'Manager' } }
                  }
                },
                creator: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Creator's unique identifier", example: 2 },
                    first_name: { type: :string, description: 'First name of the creator', example: 'John' },
                    last_name: { type: :string, description: 'Last name of the creator', example: 'Smith' },
                    email: { type: :string, description: 'Email address of the creator', example: 'john.smith@example.com' },
                    position: { type: :string, description: 'Position of the creator', example: 'Admin' },
                    licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the creator', example: '2024-12-31' },
                    employed_from: { type: :string, format: :date, description: 'Employment start date of the creator', example: '2020-01-01' },
                    employed_to: { type: :string, format: :date, description: 'Employment end date of the creator', example: '2023-01-01' },
                    roles: { type: :array, items: { type: :string, description: 'Roles of the creator', example: 'Admin' } }
                  }
                },
                vacation_for_user: {
                  type: :object,
                  description: 'Creator details',
                  properties: {
                    id: { type: :integer, description: "Creator's unique identifier", example: 2 },
                    first_name: { type: :string, description: 'First name of the creator', example: 'John' },
                    last_name: { type: :string, description: 'Last name of the creator', example: 'Smith' },
                    email: { type: :string, description: 'Email address of the creator', example: 'john.smith@example.com' },
                    position: { type: :string, description: 'Position of the creator', example: 'Admin' },
                    licence_expiration_at: { type: :string, format: :date, description: 'Licence expiration date of the creator', example: '2024-12-31' },
                    employed_from: { type: :string, format: :date, description: 'Employment start date of the creator', example: '2020-01-01' },
                    employed_to: { type: :string, format: :date, description: 'Employment end date of the creator', example: '2023-01-01' },
                    roles: { type: :array, items: { type: :string, description: 'Roles of the creator', example: 'Admin' } }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end
