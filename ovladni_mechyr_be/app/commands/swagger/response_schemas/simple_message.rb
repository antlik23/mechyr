# frozen_string_literal: true

module Swagger
  module ResponseSchemas
    class SimpleMessage
      prepend SimpleCommand

      NO_CONTENT = :no_content
      NO_CONTENT_DESCRIPTION = 'Error message'
      ERROR = :error
      ERROR_DESCRIPTION = 'Error message'
      STATUS = :status
      STATUS_DESCRIPTION = 'Status message'

      attr_reader :example, :type

      def initialize(type, example)
        @type = type
        @example = example
      end

      def call
        case type
        when NO_CONTENT
          no_content_message
        when ERROR
          error_message_schema
        when STATUS
          status_message_schema
        end
      end

      private

      def no_content_message
        {
          message: { type: :string, description: NO_CONTENT_DESCRIPTION, example: }
        }
      end

      def error_message_schema
        {
          error: { type: :string, description: ERROR_DESCRIPTION, example: }
        }
      end

      def status_message_schema
        {
          message: { type: :string, description: STATUS_DESCRIPTION, example: }
        }
      end
    end
  end
end
