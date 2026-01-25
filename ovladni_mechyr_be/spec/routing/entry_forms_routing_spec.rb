# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EntryFormsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/entry_forms').to route_to('api/v1/entry_forms#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/entry_forms/1').to route_to('api/v1/entry_forms#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/entry_forms').to route_to('api/v1/entry_forms#create')
    end
  end
end
