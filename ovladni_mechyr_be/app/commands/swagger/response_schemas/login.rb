# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Login
      prepend SimpleCommand

      def call; end

      def create
        {
          access_token: {
            type: :string,
            description: 'Access token for authentication',
            example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            required: true
          },
          refresh_token: {
            type: :string,
            description: 'Token used to refresh the access token',
            example: '8xLOxBtZp8',
            required: true
          },
          expires_in: {
            type: :integer,
            description: 'Time in seconds until the access token expires',
            example: 3600,
            required: true
          },
          user: {
            type: :object,
            properties: {
              id: {
                type: :integer,
                description: "User's unique identifier",
                example: 1
              },
              email: {
                type: :string,
                description: "User's email address",
                example: 'user@example.com'
              },
              full_name: {
                type: :string,
                description: "User's full name",
                example: 'John Doe',
                nullable: true
              },
              roles: {
                type: :array,
                items: {
                  type: :string,
                  example: 'admin'
                },
                description: 'List of roles assigned to the user'
              }
            },
            required: ['id', 'email', 'full_name', 'roles']
          }
        }
      end
    end
  end
end
