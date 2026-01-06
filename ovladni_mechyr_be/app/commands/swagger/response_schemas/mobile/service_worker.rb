# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    module Mobile
      class ServiceWorker
        prepend SimpleCommand

        def call; end

        def show
          {
            service: {
              type: :object,
              properties: {
                id: {
                  type: :integer,
                  description: 'Unique identifier for the service',
                  example: 1
                },
                repair_place: {
                  type: :string,
                  description: 'Location where the repair is to be performed',
                  example: '123 Repair Street, City, State'
                },
                reporter_fault_type: {
                  type: :string,
                  description: 'Type of fault reported by the reporter',
                  example: 'mechanical'
                },
                handover_date: {
                  type: :string,
                  format: 'date-time',
                  description: 'Date and time when the service was handed over',
                  example: '2024-06-15T09:00:00Z'
                },
                engineer_fault_type: {
                  type: :string,
                  description: 'Type of fault identified by the engineer',
                  example: 'electrical'
                },
                service_parts: {
                  type: :array,
                  description: 'List of parts associated with the service',
                  items: {
                    type: :object,
                    properties: {
                      id: {
                        type: :integer,
                        description: 'Unique identifier for the service part',
                        example: 101
                      }
                    },
                    required: ['id'],
                    additionalProperties: false
                  }
                }
              },
              required: ['id', 'repair_place', 'reporter_fault_type', 'handover_date', 'engineer_fault_type', 'service_parts'],
              additionalProperties: false
            }
          }
        end

        def index
          {
            pagination: {
              type: :object,
              properties: {
                count: { type: :integer, description: 'Total number of services available', example: 100 },
                page: { type: :integer, description: 'Current page number', example: 1 },
                next: { type: :integer, nullable: true, description: 'Next page number if available', example: 2 },
                pages: { type: :integer, description: 'Total number of pages', example: 5 },
                items: { type: :integer, description: 'Number of services per page', example: 20 }
              }
            },

            services: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, description: 'Unique identifier for the service', example: 1 },
                  engineer_fault_type: { type: :string, description: 'Type of fault identified by the engineer', example: 'Electrical' },

                  machine: {
                    type: :object,
                    description: 'Details of the machine associated with the service',
                    properties: {
                      id: { type: :integer, description: 'Unique identifier for the machine', example: 101 },
                      name: { type: :string, description: 'Name of the machine', example: 'Excavator' },
                      registration: { type: :string, description: 'Registration number of the machine', example: 'ABC123' },
                      motorcycle_hours: { type: :integer, description: 'Motorcycle hours logged by the machine', example: 1200 }
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
end
