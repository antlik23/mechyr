# frozen_string_literal: true

module Api
  module V1
    class ExportsController < ApplicationController
      def export
        return if authorize_action(roles: %i[admin])

        model_name = params[:model_name]
        translated_model_name = I18n.t("exports.model_names.#{model_name}")

        begin
          xls_stream = XlsGenerator.generate(model_name)

          send_data(
            xls_stream.string,
            filename: "#{translated_model_name}_export_#{Time.current.strftime('%Y%m%d%H%M%S')}.xls",
            type: 'application/vnd.ms-excel',
            disposition: 'attachment'
          )
        end
      end
    end
  end
end
