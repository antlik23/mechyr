# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cloudinary::Download do
  describe '#call image' do
    let(:blob) { double(image?: true, key: 'key_test') }
    it 'return url for image key' do
      command = described_class.call(blob)
      expect(command.success?).to be_truthy
      expect(command.result).to eq('https://res.cloudinary.com/dpc2mp4uv/image/upload/fl_attachment/key_test?_a=BACADKDL')
    end
  end

  describe '#call documents' do
    let(:blob) { double(image?: false, video?: false, key: 'key_test') }
    it 'return url for documents key' do
      command = described_class.call(blob)
      expect(command.success?).to be_truthy
      expect(command.result).to eq('https://res.cloudinary.com/dpc2mp4uv/raw/upload/fl_attachment/key_test?_a=BACADKDL')
    end
  end
end
