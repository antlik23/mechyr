# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found
  end

  def exception
    render json: { error: I18n.t('errors.messages.internal_server_error') }.to_json, status: :internal_server_error
  end
end
