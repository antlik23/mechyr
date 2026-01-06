# frozen_string_literal: true

module Invitations
  class Accept
    prepend SimpleCommand

    attr_reader :accept_invitation_params, :request

    def initialize(accept_invitation_params, request)
      @accept_invitation_params = accept_invitation_params
      @request = request
    end

    def call
      accept
      login_user
    end

    private

    def accept
      @user = User.accept_invitation!(accept_invitation_params)
    end

    def login_user
      Logins::Create.call(login_params, request).result
    end

    def login_params
      { email: @user.email, password: accept_invitation_params[:password] }
    end
  end
end
