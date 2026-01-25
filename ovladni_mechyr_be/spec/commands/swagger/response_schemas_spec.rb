# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'swagger schemas' do
  describe '#call' do
    it 'return true' do
      command = Swagger::ResponseSchemas::Invoice.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)

      command = Swagger::ResponseSchemas::Login.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:create)

      command = Swagger::ResponseSchemas::Machine.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)

      command = Swagger::ResponseSchemas::Notification.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)

      command = Swagger::ResponseSchemas::Part.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)

      command = Swagger::ResponseSchemas::ServicePart.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)

      command = Swagger::ResponseSchemas::Signup.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:create)

      command = Swagger::ResponseSchemas::User.call
      expect(command.success?).to be_truthy
      expect(command).to respond_to(:timesheets)
      expect(command).to respond_to(:show)
      expect(command).to respond_to(:index)
    end
  end
end
