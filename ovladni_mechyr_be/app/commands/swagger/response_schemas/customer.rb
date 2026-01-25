# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Customer
      prepend SimpleCommand

      def call; end

      def show
        {
          customer: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Customer's unique identifier", example: 1 },
              name: { type: :string, description: "Customer's name", example: 'John Doe' },
              ico: { type: :string, description: 'ICO of the customer', example: '12345678' },
              dic: { type: :string, description: 'DIC of the customer', example: 'CZ12345678' },
              address: { type: :string, description: 'Address of the customer', example: '123 Main St' },
              email: { type: :string, description: 'Email of the customer', example: 'john.doe@example.com' },
              phone: { type: :string, description: 'Phone number of the customer', example: '+420123456789' },
              url: { type: :string, description: "URL of the customer's website", example: 'http://example.com' },
              machines: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Machine's unique identifier", example: 1 },
                    name: { type: :string, description: 'Name of the machine', example: 'Excavator' },
                    registration: { type: :string, description: 'Registration of the machine', example: 'ABC123' },
                    locomotive: { type: :boolean, description: 'Is the machine a locomotive', example: false },
                    motorcycle_hours: { type: :integer, description: 'Motorcycle hours of the machine', example: 500 },
                    next_service_interval: { type: :integer, description: 'Next service interval of the machine', example: 1000 },
                    validity_of_licence: { type: :string, format: :date, description: 'Validity of the machine license', example: '2024-12-31' },
                    site_number: { type: :string, description: 'Site number of the machine', example: 'SN123' }
                  },
                  required: ['id', 'name', 'registration', 'locomotive', 'motorcycle_hours', 'next_service_interval', 'validity_of_licence', 'site_number']
                }
              },
              invoices: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Invoice's unique identifier", example: 1 },
                    name: { type: :string, description: 'Name of the invoice', example: 'Invoice #123' },
                    ico: { type: :string, description: 'ICO of the invoice', example: '12345678' },
                    dic: { type: :string, description: 'DIC of the invoice', example: 'CZ12345678' },
                    total: { type: :number, format: :float, description: 'Total amount of the invoice', example: 1000.50 },
                    number: { type: :string, description: 'Number of the invoice', example: 'INV-123' },
                    issue_date: { type: :string, format: :date, description: 'Issue date of the invoice', example: '2023-01-01' },
                    delivery_date: { type: :string, format: :date, description: 'Delivery date of the invoice', example: '2023-01-15' },
                    due_date: { type: :string, format: :date, description: 'Due date of the invoice', example: '2023-01-30' }
                  },
                  required: ['id', 'name', 'ico', 'dic', 'total', 'number', 'issue_date', 'delivery_date', 'due_date']
                }
              }
            },
            required: ['id', 'name', 'ico', 'dic', 'address', 'email', 'phone', 'url']
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
          customers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the customer' },
                name: { type: :string, description: 'Name of the customer' },
                ico: { type: :string, description: 'ICO of the customer' },
                dic: { type: :string, description: 'DIC of the customer' },
                address: { type: :string, description: 'Address of the customer' },
                email: { type: :string, description: 'Email of the customer' },
                phone: { type: :string, description: 'Phone number of the customer' },
                url: { type: :string, description: 'URL of the customer' }
              },
              required: ['id', 'name', 'ico', 'dic', 'address', 'email', 'phone', 'url']
            }
          }
        }
      end
    end
  end
end
