# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Notification
      prepend SimpleCommand

      def call; end

      def show
        {
          notification: {
            type: :object,
            properties: {
              id: { type: :integer, description: 'Unique identifier for the notification', example: 1 },
              user_id: { type: :integer, description: 'ID of the user who received the notification', example: 123 },
              title: { type: :string, description: 'Title of the notification', example: 'New Part Order' },
              message: { type: :string, description: 'Message body of the notification', example: 'A new part has been ordered.' },
              created_at: { type: :string, format: 'date-time', description: 'Timestamp when the notification was created', example: '2024-06-13T07:57:49.204Z' },
              read: { type: :boolean, description: 'Indicates if the notification has been read', example: false },

              body: {
                type: :object,
                properties: {
                  type: {
                    type: :string,
                    description: 'Type of the body associated with the notification',
                    enum: ['Part', 'ServicePart'],
                    example: 'Part'
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
              count: { type: :integer, description: 'Total number of notifications', example: 10 },
              page: { type: :integer, description: 'Current page number', example: 1 },
              next: { type: :integer, nullable: true, description: 'Next page number if available', example: 2 },
              pages: { type: :integer, description: 'Total number of pages', example: 5 },
              items: { type: :integer, description: 'Number of items per page', example: 20 }
            }
          },

          notifications: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, description: 'Unique identifier for the notification', example: 1 },
                user_id: { type: :integer, description: 'ID of the user who received the notification', example: 123 },
                title: { type: :string, description: 'Title of the notification', example: 'New Order Received' },
                action: { type: :string, description: 'Action related to the notification', example: 'order_placed' },
                message: { type: :string, description: 'Message body of the notification', example: 'You have received a new order.' },
                created_at: { type: :string, format: 'date-time', description: 'Timestamp when the notification was created', example: '2024-06-13T07:57:49.204Z' },
                read: { type: :boolean, description: 'Indicates if the notification has been read', example: false },

                body: {
                  type: :object,
                  properties: {
                    type: {
                      type: :string,
                      description: 'Type of the body associated with the notification',
                      enum: ['Part', 'ServicePart'],
                      example: 'Part'
                    }
                  }
                }
              }
            },
            nullable: true
          }
        }
      end
    end
  end
end
