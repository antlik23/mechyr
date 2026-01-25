# frozen_string_literal: true

module Cloudinary
  class Download
    prepend SimpleCommand

    ATTACHMENT = 'attachment'
    IMAGE = 'image'
    RAW = 'raw'

    attr_reader :blob

    def initialize(blob)
      @blob = blob
    end

    def call
      Cloudinary::Utils.cloudinary_url(blob.key, resource_type:, flags: ATTACHMENT)
    end

    private

    def resource_type
      if blob.image?
        IMAGE
      else
        RAW
      end
    end
  end
end
