# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Part
      prepend SimpleCommand

      def call; end

      def show
        {
          part: {
            type: :object,
            properties: {
              id: { type: :integer, description: 'Unique identifier for the part', example: 1 },
              name: { type: :string, description: 'Name of the part', example: 'Part Name' },
              ean: { type: :string, description: 'EAN code for the part', example: '1234567890123' },
              price_purchase: { type: :number, format: :float, description: 'Purchase price of the part', example: 100.5 },
              price_selling: { type: :number, format: :float, description: 'Selling price of the part', example: 150.0 },
              price_margin: { type: :number, format: :float, description: 'Margin on the part price', example: 49.5 },
              amount_in_stock: { type: :integer, description: 'Amount of the part in stock', example: 20 },
              amount_ordered: { type: :integer, description: 'Amount of the part ordered', example: 5 },
              unit: { type: :string, description: 'Unit of measurement for the part', example: 'pcs' },
              registrated: { type: :string, description: 'Registrated if part is in warehouse', example: 'false' },
              placement: { type: :string, description: 'Where part is', example: 'regal 3 shelf 5' },
              universal: { type: :boolean, description: 'True if can be used for every machine', example: 'true' },
              supplier: {
                type: :object,
                nullable: true,
                properties: {
                  id: { type: :integer, description: 'Unique identifier for the supplier', example: 1 },
                  name: { type: :string, description: 'Name of the supplier', example: 'Supplier Name' },
                  ico: { type: :string, description: 'ICO (Identification Number) of the supplier', example: '12345678' },
                  dic: { type: :string, description: 'DIC (Tax Identification Number) of the supplier', example: 'CZ12345678' },
                  phone: { type: :string, description: 'Phone number of the supplier', example: '+420123456789' },
                  email: { type: :string, description: 'Email address of the supplier', example: 'supplier@example.com' },
                  url: { type: :string, description: 'Website URL of the supplier', example: 'http://www.supplier.com' },
                  address: { type: :string, description: 'Physical address of the supplier', example: '123 Supplier St, City, Country' }
                }
              },
              machines: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the machine', example: 1 },
                    name: { type: :string, description: 'Name of the machine', example: 'Machine Name' }
                  }
                },
                description: 'List of machines associated with the part'
              },
              documents: {
                type: :array,
                nullable: true,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the document', example: 1 },
                    url: { type: :string, description: 'URL to access the document', example: 'http://example.com/document.pdf' },
                    filename: { type: :string, description: 'Sanitized filename of the document', example: 'document.pdf' },
                    content_type: { type: :string, description: 'MIME type of the document', example: 'application/pdf' }
                  }
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
              count: { type: :integer, description: 'Total number of items' },
              page: { type: :integer, description: 'Current page number' },
              next: { type: :string, description: 'URL to the next page of results' },
              pages: { type: :integer, description: 'Total number of pages' },
              items: { type: :integer, description: 'Number of items per page' }
            }
          },
          parts: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the part', example: 1 },
                name: { type: :string, description: 'Name of the part', example: 'Part Name' },
                ean: { type: :string, description: 'European Article Number (EAN) of the part', example: '1234567890123' },
                amount_in_stock: { type: :integer, description: 'Amount of parts currently in stock', example: 50 },
                amount_ordered: { type: :integer, description: 'Amount of parts ordered', example: 10 },
                price_purchase: { type: :number, format: :float, description: 'Purchase price of the part', example: 20.5 },
                price_selling: { type: :number, format: :float, description: 'Selling price of the part', example: 30.0 },
                price_margin: { type: :number, format: :float, description: 'Profit margin on the part', example: 9.5 },
                unit: { type: :string, description: 'Unit of measurement for the part', example: 'piece' },
                registrated: { type: :string, description: 'Registrated if part is in warehouse', example: 'false' },
                placement: { type: :string, description: 'Where part is', example: 'regal 3 shelf 5' },
                universal: { type: :boolean, description: 'True if can be used for every machine', example: 'true' },
                supplier: {
                  type: :object,
                  description: 'Supplier information for the part',
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the supplier', example: 2 },
                    name: { type: :string, description: 'Name of the supplier', example: 'Supplier Name' }
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
