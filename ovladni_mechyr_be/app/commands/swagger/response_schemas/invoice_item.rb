# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class InvoiceItem
      prepend SimpleCommand

      def call; end

      def show
        {
          invoice_item: {
            type: :object,
            properties: {
              id: { type: :integer, description: 'Unique identifier for the invoice item' },
              unit: { type: :integer, description: 'Enum pcs: 0, kg: 1, mm: 2' },
              unit_price: { type: :number, format: :decimal, description: 'Price per unit of the item' },
              count: { type: :number, format: :decimal, description: 'Quantity of the item' },
              total: { type: :number, format: :decimal, description: 'Total cost of the item' },
              invoice: {
                type: :object,
                properties: {
                  id: { type: :integer, description: 'Unique identifier for the associated invoice' }
                }
              }
            }
          }
        }
      end

      def index
        {
          pagination: pagination_properties,
          invoice_items: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the invoice item' },
                item: { type: :string, description: 'Description of the item' },
                unit: { type: :integer, description: 'Enum pcs: 0, kg: 1, mm: 2' },
                unit_price: { type: :number, format: :decimal, description: 'Price per unit of the item' },
                count: { type: :number, format: :decimal, description: 'Quantity of the item' },
                invoice: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the associated invoice' }
                  }
                }
              }
            }
          }
        }
      end

      private

      def pagination_properties
        {
          type: :object,
          properties: {
            count: { type: :integer, description: 'Total number of items' },
            page: { type: :integer, description: 'Current page number' },
            next: { type: :string, description: 'URL to the next page of results' },
            pages: { type: :integer, description: 'Total number of pages' },
            items: { type: :integer, description: 'Number of items per page' }
          }
        }
      end
    end
  end
end
