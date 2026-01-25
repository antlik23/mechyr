# frozen_string_literal: true

# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  let(:valid_attributes) do
    attributes_for(:service_part)
  end
end
