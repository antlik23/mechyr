# frozen_string_literal: true

module Signature
  class Upload
    prepend SimpleCommand
    attr_reader :job, :signature

    def initialize(job, signature)
      @job = job
      @signature = signature
    end

    def call
      return error_message unless job.is_a?(H2PrimeJob)

      attach_signature
    end

    private

    def error_message
      errors.add(:job, I18n.t('commands.signature.only_new_job'))
    end

    def save_dimension(blob)
      return unless blob.image?

      dimensions = ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick.new(blob).metadata
      blob.update(metadata: blob.metadata.reverse_merge!(dimensions))
    end

    def attach_signature
      job.signature.attach(signature)
      save_dimension(job.signature.blob)
    end
  end
end
