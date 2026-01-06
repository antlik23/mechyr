# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Invoice
      prepend SimpleCommand

      def call; end

      def show
        {
          invoice: {
            type: :object,
            properties: {
              id: { type: :integer, description: 'Unique identifier for the invoice' },
              number: { type: :string, description: 'Invoice number' },
              name: { type: :string, description: 'Invoice name' },
              ico: { type: :string, description: 'Company identification number (ICO)' },
              dic: { type: :string, description: 'Tax identification number (DIC)' },
              total: { type: :number, format: :decimal, description: 'Total amount of the invoice' },
              issue_date: { type: :string, format: :date, description: 'Date the invoice was issued' },
              delivery_date: { type: :string, format: :date, description: 'Expected delivery date for the goods or services' },
              due_date: { type: :string, format: :date, description: 'Date by which the invoice payment is due' },
              service: service_properties,
              customer: customer_properties,
              documents: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Document's unique identifier", example: 1 },
                    url: { type: :string, description: 'URL of the document', example: 'https://example.com/document.pdf' },
                    thumbnail_url: { type: :string, description: 'Thumbnail URL of the document', example: 'https://example.com/thumbnail.jpg' },
                    download_url: { type: :string, description: 'Download URL of the document', example: 'https://example.com/download.pdf' },
                    filename: { type: :string, description: 'Sanitized filename of the document', example: 'document.pdf' },
                    content_type: { type: :string, description: 'Content type of the document', example: 'application/pdf' },
                    height: { type: :integer, description: 'Height of the image document, if applicable', example: 1080 },
                    width: { type: :integer, description: 'Width of the image document, if applicable', example: 1920 }
                  }
                }
              },
              invoice_items: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: 'Unique identifier for the invoice item' },
                    unit: { type: :string, description: 'Unit of measurement for the item' },
                    unit_price: { type: :number, format: :decimal, description: 'Price per unit of the item' },
                    count: { type: :integer, description: 'Quantity of the item' },
                    total: { type: :number, format: :decimal, description: 'Total cost of the item' }
                  }
                }
              },
              total_item_cost: { type: :number, format: :decimal, description: 'Total cost of all items in the invoice', default: 0 }
            }
          }
        }
      end

      def index
        {
          pagination: pagination_properties,
          invoices: {
            type: :array,
            items: {
              type: :object,
              properties: invoice_properties
            }
          }
        }
      end

      def processed
        {
          pagination: pagination_properties,
          invoices: {
            type: :array,
            items: {
              type: :object,
              properties: invoice_properties
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

      def invoice_properties
        {
          id: { type: :integer, description: 'Unique identifier for the invoice' },
          number: { type: :string, description: 'Invoice number' },
          name: { type: :string, description: 'Invoice name' },
          ico: { type: :string, description: 'Company identification number (ICO)' },
          dic: { type: :string, description: 'Tax identification number (DIC)' },
          total: { type: :number, format: :decimal, description: 'Total amount of the invoice' },
          issue_date: { type: :string, format: :date, description: 'Date the invoice was issued' },
          delivery_date: { type: :string, format: :date, description: 'Expected delivery date for the goods or services' },
          due_date: { type: :string, format: :date, description: 'Date by which the invoice payment is due' },
          service: service_properties,
          customer: customer_properties
        }
      end

      def service_properties
        {
          type: :object,
          properties: {
            id: { type: :integer, description: 'Unique identifier for the service' },
            repair_place: { type: :string, description: 'Location of the repair' },
            handover_date: { type: :string, format: :date, description: 'Date the service was handed over' },
            reporting_date: { type: :string, format: :date, description: 'Date the issue was reported' },
            reporter_fault_type: { type: :string, description: 'Fault type reported by the customer' },
            engineer_fault_type: { type: :string, description: 'Fault type identified by the engineer' },
            estimated_completion: { type: :string, format: :date, description: 'Estimated date for service completion' },
            reporter: reporter_properties,
            machine: machine_properties
          }
        }
      end

      def customer_properties
        {
          type: :object,
          properties: {
            id: { type: :integer, description: 'Unique identifier for the customer' },
            name: { type: :string, description: 'Customer name' },
            ico: { type: :string, description: 'Company identification number (ICO)' },
            dic: { type: :string, description: 'Tax identification number (DIC)' },
            address: { type: :string, description: 'Customer address' },
            email: { type: :string, description: 'Customer email' },
            phone: { type: :string, description: 'Customer phone number' },
            url: { type: :string, description: 'Customer website URL' }
          }
        }
      end

      def reporter_properties
        {
          type: :object,
          properties: {
            id: { type: :integer, description: 'Unique identifier for the reporter' },
            first_name: { type: :string, description: 'First name of the reporter' },
            last_name: { type: :string, description: 'Last name of the reporter' },
            position: { type: :string, description: 'Position of the reporter' }
          }
        }
      end

      def machine_properties
        {
          type: :object,
          properties: {
            id: { type: :integer, description: 'Unique identifier for the machine' },
            name: { type: :string, description: 'Name of the machine' },
            registration: { type: :string, description: 'Machine registration' },
            locomotive: { type: :boolean, description: 'Indicates if the machine is a locomotive' },
            motorcycle_hours: { type: :integer, description: 'Total motorcycle hours', default: 0 },
            next_service_interval: { type: :integer, description: 'Next service interval', default: 0 },
            validity_of_licence: { type: :string, format: :date, description: 'Validity date of the licence' },
            validity_of_exams: { type: :string, format: :date, description: 'Validity date of the exams' }
          }
        }
      end
    end
  end
end
