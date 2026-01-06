# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_devise_api_token!
  before_action :set_locale

  def current_user_is_admin?
    current_devise_api_user.has_role?(Role::ADMIN)
  end

  def current_user_is_doctor?
    current_devise_api_user.has_role?(Role::DOCTOR)
  end

  def current_user_is_patient?
    current_devise_api_user.has_role?(Role::PATIENT)
  end

  def authorize_action(roles:)
    permitted = roles.any? { |role| current_devise_api_user.send("#{role}?") }
    render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found unless permitted
  end

  def set_locale
    language = params[:lang]

    return if language.blank?

    if language.present? && I18n.available_locales.map(&:to_s).exclude?(language)
      render json: {
        status: 400,
        error: 'Invalid language parameter provided'
      }, status: :bad_request
      return
    end
    I18n.locale = language
  end

  def respond_with_error(error, status = :not_found)
    render json: { error: }, status:
  end

  def authenticate_devise_api_token!
    if current_devise_api_token.nil?
      error_response = { error: I18n.t('devise.api.error_response.invalid_token') }
      return render json: error_response, status: :unauthorized
    end

    return unless current_devise_api_token.expired?

    error_response = { error: I18n.t('devise.api.error_response.expired_token') }
    return render json: error_response, status: :unauthorized
  end

  def page_param
    return 1 if params[:page_param].blank?
    return 1 if params[:page_param].to_i < 1

    params[:page_param]
  end

  def set_patient_from_user
    user = User.find(params[resource_name][:user_id])
    patient = user.patient
    params[resource_name][:patient_id] = patient.id
    params[resource_name].delete(:user_id)
  end

  def resource_name
    controller_name.singularize
  end

  def route_not_found
    render inline: '404 - not found', status: :not_found, content_type: 'text/html', layout: false
  end
end
