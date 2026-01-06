# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Machine
      prepend SimpleCommand

      def call; end

      def show
        {
          machine: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Machine's unique identifier", example: 1 },
              name: { type: :string, description: 'Name of the machine', example: 'Excavator' },
              registration: { type: :string, description: 'Registration number of the machine', example: 'ABC-123' },
              locomotive: { type: :string, description: 'Locomotive type of the machine', example: 'Type A' },
              motorcycle_hours: { type: :integer, description: 'Total motorcycle hours of the machine', example: 1000 },
              next_service_interval: { type: :integer, description: 'Next service interval for the machine', example: 500 },
              validity_of_licence: { type: :string, format: :date, description: 'Validity of the machine license', example: '2024-12-31' },
              validity_of_exams: { type: :string, format: :date, description: 'Validity of the machine exams', example: '2023-06-30' },
              site_number: { type: :string, description: 'Site number of the machine', example: '1' },
              licence: { type: :string, description: 'Licence of the machine', example: '1' },
              certificate: { type: :string, description: 'Certificate of the machine', example: '1' },
              note: { type: :string, description: 'Note about the machine', example: 'long long note' },
              ean: { type: :string, description: 'EAN unique number of the machine', example: 'FD213-341' },

              customer: {
                type: :object,
                description: 'Customer details',
                properties: {
                  id: { type: :integer, description: "Customer's unique identifier", example: 1 },
                  name: { type: :string, description: 'Name of the customer', example: 'John Doe' },
                  ico: { type: :string, description: 'ICO number of the customer', example: '12345678' },
                  dic: { type: :string, description: 'DIC number of the customer', example: '87654321' },
                  address: { type: :string, description: 'Address of the customer', example: '123 Main St' },
                  email: { type: :string, description: 'Email address of the customer', example: 'john.doe@example.com' },
                  phone: { type: :string, description: 'Phone number of the customer', example: '+1234567890' },
                  url: { type: :string, description: 'Website URL of the customer', example: 'https://example.com' }
                }
              },

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

              services: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Service's unique identifier", example: 1 },
                    repair_place: { type: :string, description: 'Place where the repair took place', example: 'Workshop A' },
                    handover_date: { type: :string, format: :date, description: 'Date of handover', example: '2023-05-01' },
                    reporting_date: { type: :string, format: :date, description: 'Date when the issue was reported', example: '2023-04-25' },
                    reporter_fault_type: { type: :string, description: 'Type of fault reported', example: 'Mechanical' },
                    estimated_completion: { type: :string, format: :date, description: 'Estimated date of completion', example: '2023-06-01' }
                  }
                }
              },

              certificates: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Certificate's unique identifier", example: 1 },
                    name: { type: :string, description: 'Name of the certificate', example: 'Safety Certificate' },
                    end_date: { type: :string, format: :date, description: 'End date of the certificate', example: '2024-12-31' },
                    certifiable_id: { type: :integer, description: 'ID of the certifiable entity', example: 1 },
                    certifiable_type: { type: :string, description: 'Type of the certifiable entity (e.g., User or Machine)', example: 'Machine' }
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
              count: { type: :integer, description: 'Total number of items', example: 50 },
              page: { type: :integer, description: 'Current page number', example: 1 },
              next: { type: :integer, description: 'Next page number, if applicable', example: 2 },
              pages: { type: :integer, description: 'Total number of pages', example: 5 },
              items: { type: :integer, description: 'Number of items per page', example: 10 }
            }
          },
          machines: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: "Machine's unique identifier", example: 1 },
                name: { type: :string, description: 'Name of the machine', example: 'Excavator' },
                registration: { type: :string, description: 'Registration number of the machine', example: 'ABC-123' },
                locomotive: { type: :string, description: 'Locomotive type of the machine', example: 'Type A' },
                motorcycle_hours: { type: :integer, description: 'Total motorcycle hours of the machine', example: 1000 },
                next_service_interval: { type: :integer, description: 'Next service interval for the machine', example: 500 },
                validity_of_licence: { type: :string, format: :date, description: 'Validity of the machine license', example: '2024-12-31' },
                validity_of_exams: { type: :string, format: :date, description: 'Validity of the machine exams', example: '2023-06-30' },
                ean: { type: :string, description: 'Ean uniq number of a machine', example: 'FD213-341' },
                created_at: { type: :string, format: :date_time, description: 'Date and time when the machine was created', example: '2023-04-25T14:12:03Z' },
                customer: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: "Customer's unique identifier", example: 1 },
                    name: { type: :string, description: 'Name of the customer', example: 'John Doe' },
                    ico: { type: :string, description: 'ICO number of the customer', example: '12345678' },
                    dic: { type: :string, description: 'DIC number of the customer', example: '87654321' },
                    address: { type: :string, description: 'Address of the customer', example: '123 Main St' },
                    email: { type: :string, description: 'Email address of the customer', example: 'john.doe@example.com' },
                    phone: { type: :string, description: 'Phone number of the customer', example: '+1234567890' },
                    url: { type: :string, description: 'Website URL of the customer', example: 'https://example.com' }
                  }
                },
                machinists: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer, description: "Machinist's unique identifier", example: 1 },
                      first_name: { type: :string, description: "Machinist's first name", example: 'Jane' },
                      last_name: { type: :string, description: "Machinist's last name", example: 'Doe' },
                      email: { type: :string, description: "Machinist's email address", example: 'jane.doe@example.com' },
                      position: { type: :string, description: "Machinist's position", example: 'Operator' },
                      licence_expiration_at: { type: :string, format: :date, description: "Machinist's license expiration date", example: '2024-12-31' },
                      employed_from: { type: :string, format: :date, description: "Machinist's employment start date", example: '2020-01-01' },
                      employed_to: { type: :string, format: :date, description: "Machinist's employment end date", example: '2023-01-01' },
                      roles: { type: :array, items: { type: :string, description: "Machinist's roles", example: 'Engineer' } }
                    }
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
