# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'welcome_email' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@uzis.com'])
    end
  end
end
