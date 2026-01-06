# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Certificate
      prepend SimpleCommand

      def call; end

      def show
        {
          certificate: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Certificate's unique identifier", example: 1 },
              name: { type: :string, description: 'Name of the certificate', example: 'Certificate of Excellence' },
              end_date: { type: :string, format: :date, description: 'End date of the certificate', example: '2024-12-31' },
              certifiable_id: { type: :integer, description: 'ID of the associated certifiable entity (e.g., User)', example: 1 },
              certifiable_type: { type: :string, description: 'Type of the associated certifiable entity (e.g., User)', example: 'User' }
            },
            required: ['id', 'name', 'end_date', 'certifiable_id', 'certifiable_type']
          }
        }
      end

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
          certificates: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the certificate' },
                name: { type: :string, description: 'Name of the certificate' },
                end_date: { type: :string, format: :date, description: 'End date of the certificate' },
                certifiable_id: { type: :integer, description: 'ID of the associated certifiable entity' },
                certifiable_type: { type: :string, description: 'Type of the associated certifiable entity (e.g., User)' }
              },
              required: ['id', 'name', 'end_date', 'certifiable_id', 'certifiable_type']
            }
          }
        }
      end
    end
  end
end
