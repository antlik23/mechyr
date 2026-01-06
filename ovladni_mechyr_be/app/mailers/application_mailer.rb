# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@uzis.com'
  layout 'mailer'
end
