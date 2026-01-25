# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class Signup
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
              first_name: {
                type: :string,
                description: "User's first name",
                example: 'John'
              },
              last_name: {
                type: :string,
                description: "User's last name",
                example: 'Doe'
              },
              role: {
                type: :string,
                description: "User's primary role",
                example: 'admin'
              }
            },
            required: ['id', 'email', 'first_name', 'last_name', 'role']
          }
        }
      end
    end
  end
end
