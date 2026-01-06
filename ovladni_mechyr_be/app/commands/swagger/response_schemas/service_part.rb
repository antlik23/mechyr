# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class ServicePart
      prepend SimpleCommand

      def call; end

      def show
        {
          service_part: {
            type: :object,
            properties: {
              amount_to_order: { type: :integer, description: 'Amount of the part to order', example: 10 },
              amount_ordered: { type: :integer, description: 'Amount of the part ordered', example: 5 },
              amount_to_service: { type: :integer, description: 'Amount of the part to service', example: 3 },
              amount_serviced: { type: :integer, description: 'Amount of the part serviced', example: 2 },
              amount_in_stock: { type: :integer, description: 'Amount of the part in stock', example: 100 },

              documents: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Document's unique identifier", example: 1 },
                    url: { type: :string, description: 'URL to access the document', example: 'http://example.com/document.pdf' },
                    filename: { type: :string, description: 'Sanitized filename of the document', example: 'document.pdf' },
                    content_type: { type: :string, description: 'MIME type of the document', example: 'application/pdf' }
                  },
                  required: ['id', 'url', 'filename', 'content_type']
                }
              },

              part: {
                type: :object,
                properties: {
                  id: { type: :integer, description: "Part's unique identifier", example: 1 },
                  name: { type: :string, description: 'Name of the part', example: 'Engine Part' },
                  ean: { type: :string, description: 'EAN code of the part', example: '1234567890123' },
                  unit: { type: :string, description: 'Unit of the part', example: 'kg' },
                  price_purchase: { type: :number, format: :float, description: 'Purchase price of the part', example: 12.34 },
                  price_selling: { type: :number, format: :float, description: 'Selling price of the part', example: 23.45 },
                  price_margin: { type: :number, format: :float, description: 'Margin on the part price', example: 11.11 },
                  registrated: { type: :string, format: :date, description: 'Date the part was registered', example: '2023-01-15' },
                  placement: { type: :string, description: 'Storage placement of the part', example: 'Shelf A1' },
                  universal: { type: :boolean, description: 'Indicates if the part is universal for all machines', example: false },

                  supplier: {
                    type: :object,
                    properties: {
                      id: { type: :integer, description: "Supplier's unique identifier", example: 1 },
                      name: { type: :string, description: 'Name of the supplier', example: 'Supplier Inc.' },
                      ico: { type: :string, description: 'ICO of the supplier', example: '12345678' },
                      dic: { type: :string, description: 'DIC of the supplier', example: 'CZ12345678' },
                      phone: { type: :string, description: 'Phone number of the supplier', example: '+420123456789' },
                      email: { type: :string, description: 'Email address of the supplier', example: 'supplier@example.com' },
                      url: { type: :string, description: "URL of the supplier's website", example: 'http://example.com' },
                      address: { type: :string, description: 'Address of the supplier', example: '123 Supplier Street, Supplier City' }
                    },
                    required: ['id', 'name', 'ico', 'dic', 'phone', 'email', 'url', 'address']
                  },

                  machines: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, description: "Machine's unique identifier", example: 1 },
                        name: { type: :string, description: 'Name of the machine associated with this part', example: 'Excavator' }
                      }
                    }
                  }
                },
                required: ['id', 'name', 'ean', 'price_purchase', 'price_selling', 'price_margin']
              }
            },
            required: ['amount_to_order', 'amount_ordered', 'amount_to_service', 'amount_serviced', 'amount_in_stock']
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
          service_parts: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the service part' },
                amount_to_order: { type: :integer, description: 'Amount to order for the service part' },
                amount_ordered: { type: :integer, description: 'Amount ordered for the service part' },
                amount_to_service: { type: :integer, description: 'Amount to service for the service part' },
                amount_serviced: { type: :integer, description: 'Amount serviced for the service part' },
                service: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the service' },
                    entry_number: { type: :string, description: 'Entry number of the service' }
                  },
                  required: ['id', 'entry_number']
                },
                part: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the part' },
                    name: { type: :string, description: 'Name of the part' },
                    ean: { type: :string, description: 'EAN code of the part' },
                    amount_in_stock: { type: :integer, description: 'Amount of the part in stock' },
                    amount_ordered: { type: :integer, description: 'Amount of the part ordered' },
                    unit: { type: :string, description: 'Unit of the part' },
                    price_purchase: { type: :number, description: 'Purchase price of the part' },
                    price_selling: { type: :number, description: 'Selling price of the part' },
                    price_margin: { type: :number, description: 'Margin price of the part' },
                    supplier: {
                      type: :object,
                      properties: {
                        id: { type: :integer, description: 'Unique identifier for the supplier' },
                        name: { type: :string, description: 'Name of the supplier' },
                        ico: { type: :string, description: 'ICO of the supplier' },
                        dic: { type: :string, description: 'DIC of the supplier' },
                        phone: { type: :string, description: 'Phone number of the supplier' },
                        email: { type: :string, description: 'Email address of the supplier' },
                        url: { type: :string, description: 'URL of the supplier' },
                        address: { type: :string, description: 'Address of the supplier' }
                      },
                      required: ['id', 'name']
                    }
                  },
                  required: ['id', 'name', 'ean', 'amount_in_stock', 'amount_ordered', 'unit', 'price_purchase', 'price_selling', 'price_margin']
                }
              },
              required: ['id', 'amount_to_order', 'amount_ordered', 'amount_to_service', 'amount_serviced']
            }
          }
        }
      end
    end
  end
end
