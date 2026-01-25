# frozen_string_literal: true

module Cloudinary
  class Thumbnail
    prepend SimpleCommand

    attr_reader :blob, :width, :height, :crop

    def initialize(blob, width = 400, height = 400, crop = 'fit')
      @blob = blob
      @width = width
      @height = height
      @crop = crop
    end

    def call
      if blob.image?
        Cloudinary::Utils.cloudinary_url(blob.key, width:, height:, crop:)
      else
        String.new
      end
    end
  end
end
