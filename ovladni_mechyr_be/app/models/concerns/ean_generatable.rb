# frozen_string_literal: true

module EanGeneratable
  extend ActiveSupport::Concern

  ONLY_NUMBERS = /^\d+$/

  included do
    before_validation :generate_ean
    before_save :regenerate_barcode_if_ean_changed, unless: -> { Rails.env.test? }

    validate :ean_uniq_and_size

    scope :with_highest_ean, -> { where("ean ~ '^[0-9]+$'").order(Arel.sql('CAST(ean AS BIGINT) DESC')).limit(1) }
  end

  private

  def regenerate_barcode_if_ean_changed
    return unless new_record? || will_save_change_to_ean?

    Barcodes::GeneratePdf.call(self)
  end

  def ean_uniq_and_size
    return if ean.blank?

    errors.add(:ean, I18n.t('commands.parts.ean_only_numbers')) unless ean.match?(ONLY_NUMBERS)
    errors.add(:ean, I18n.t('commands.parts.ean_invalid_length')) if ean.size > 13

    return if self.class.where.not(id:).find_by(ean:).blank?

    errors.add(:ean, I18n.t('commands.parts.ean_exists'))
  end

  def generate_ean
    self.ean = generate_next if ean.blank?
  end

  def generate_next
    Eans::GenerateNext.call(self.class).result
  end
end
