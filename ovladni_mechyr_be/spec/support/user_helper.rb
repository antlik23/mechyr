# frozen_string_literal: true

def admin
  @admin ||= begin
    admin = create(:user, role: 0, email: 'admin@example.com')
    admin.roles = [Role.find_by(name: Role::ADMIN) || create(:role)]
    admin.save
    admin
  end
end

def authorization_as_patient
  before do
    sign_in_as(user_patient)
  end

  let(:Authorization) { "Bearer #{user_patient.access_tokens.take.access_token}" }
end

def authorization_as_doctor
  before do
    sign_in_as(user_doctor)
  end

  let(:Authorization) { "Bearer #{user_doctor.access_tokens.take.access_token}" }
end

def authorization_as_admin
  before do
    sign_in_as(user_admin)
  end

  let(:Authorization) { "Bearer #{user_admin.access_tokens.take.access_token}" }
end

def sign_in_as(user = admin)
  @sign_in_as ||= begin
    access_token_value = Devise.api.config.base_token_model.constantize.generate_uniq_access_token(User)
    refresh_token_value = Devise.api.config.base_token_model.constantize.generate_uniq_refresh_token(User)
    expires_in = Devise.api.config.access_token.expires_in

    user.access_tokens.create(
      access_token: access_token_value, # Explicitly use the generated value
      refresh_token: refresh_token_value, # Explicitly use the generated value
      expires_in: expires_in,
      revoked_at: nil,
      previous_refresh_token: nil
      # ... any other required attributes ...
    )
    user.access_tokens
  end
end

def valid_headers
  @valid_headers ||= { 'Authorization' => "Bearer #{sign_in_as.find_by(revoked_at: nil).access_token}" }
end
