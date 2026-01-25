# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cloudinary::Thumbnail do
  describe '#call' do
    let(:blob) { double(image?: true, key: 'key_test') }
    it 'return url for key' do
      command = described_class.call(blob)
      expect(command.success?).to be_truthy
      expect(command.result).to eq('https://res.cloudinary.com/dpc2mp4uv/image/upload/c_fit,h_400,w_400/key_test?_a=BACADKDL')
    end

    it 'return url for key and params' do
      command = described_class.call(blob, 100, 100, 'auto')
      expect(command.success?).to be_truthy
      expect(command.result).to eq('https://res.cloudinary.com/dpc2mp4uv/image/upload/c_auto,h_100,w_100/key_test?_a=BACADKDL')
    end
  end
end
