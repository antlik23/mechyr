# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EntryForm, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      entry_form = EntryForm.new(urinations_per_day: 5, fluid_intake_volume: 1.5, urination_frequency_issue: 0)
      expect(entry_form).to be_valid
    end

    it 'is invalid with negative urinations_per_day' do
      entry_form = EntryForm.new(urinations_per_day: -1, fluid_intake_volume: 1.5, urination_frequency_issue: 0)
      expect(entry_form).not_to be_valid
      expect(entry_form.errors[:urinations_per_day]).to include('musí být větší nebo rovno 0')
    end

    it 'is invalid with negative fluid_intake_volume' do
      entry_form = EntryForm.new(urinations_per_day: 5, fluid_intake_volume: -0.5, urination_frequency_issue: 0)
      expect(entry_form).not_to be_valid
      expect(entry_form.errors[:fluid_intake_volume]).to include('musí být větší nebo rovno 0')
    end
  end
end
