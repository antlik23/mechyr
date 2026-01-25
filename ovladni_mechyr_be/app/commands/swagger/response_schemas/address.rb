# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Address
      prepend SimpleCommand

      def call; end

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
                address_line_1: { type: :string, description: 'Address first line', example: 'Mirove namesti' },
                address_line_2: { type: :string, description: 'Address second line', example: 'Mirove namesti' },
                postcode: { type: :string, description: 'Postcode', example: '4007' }
              }
            }
          }
        }
      end
    end
  end
end
