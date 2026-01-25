# frozen_string_literal: true

require 'spreadsheet'
require 'stringio'

class XlsGenerator
  def self.generate(model_name)
    model_columns_config = CSV_EXPORT_COLUMNS[model_name] || {}

    model_class = model_name.constantize
    records = model_class.all

    all_columns = model_class.attribute_names.dup
    all_columns += ['gender', 'patient_public_id', 'doctor_name']

    case model_name
    when 'VoidingDiary'
      all_columns += ['max_voided_volume', 'median_voided_volume', 'average_voided_volume', 'fluid_intake_volume', 'voided_volume',
                      'nocturnal_voided_volume', 'polyuria', 'nocturnal_polyuria_index', 'urination_frequency', 'nocturnal_voids',
                      'urgencies', 'urgent_incontinence', 'incontinence_episodes']

    when 'EntryForm'
      all_columns += ['consent', 'user_involvement']
    when 'IpssForm'
      all_columns += ['quality_of_life_evaluation']
    end
    all_columns.delete('patient_id')

    columns_mapping = all_columns.to_h do |col|
      mapped_name = model_columns_config[col.to_s] || model_columns_config[col.to_sym]
      [col, mapped_name || col.titleize]
    end

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: model_name)

    header_format = Spreadsheet::Format.new(weight: :bold)

    sheet.row(0).concat(columns_mapping.values)
    sheet.row(0).default_format = header_format

    row_index = 1
    records.find_each do |record|
      row_values = columns_mapping.keys.map do |col|
        case col
        when 'gender'
          CsvExportEnums.gender(record.patient&.send(col))
        when 'doctor_name'
          record.patient&.doctor&.full_name
        when 'patient_public_id'
          record.patient&.patient_public_id
        when 'daytime_urination_frequency', 'unpleasant_urination_urge', 'sudden_urination_urge', 'occasional_leak',
          'nighttime_urination', 'waking_up_to_urinate', 'uncontrollable_urge', 'leak_due_to_intense_urge',
          'incomplete_emptying', 'intermittent_urination', 'urgency', 'weak_stream', 'straining', 'frequency'
          method_name = record.class.name.underscore
          CsvExportEnums.send(method_name, record.send(col))
        when 'leakage_frequency', 'leakage_assessment', 'nocturnal_urination', 'diagnosis', 'prescribed_medication',
          'reason_treatment_not_started', 'discontinuation_reason', 'current_treatment', 'dosage_unit', 'cesarean_section',
          'continuing_treatment'
          CsvExportEnums.send(col, record.send(col))
        when 'consent'
          1
        when 'quality_of_life_evaluation'
          CsvExportEnums.quality_of_life_evaluation(record.quality_of_life)
        when 'user_involvement'
          user_involvement = I18n.t('user_involvement.not_registered_without_issues') if !record.issue_present && record.patient&.id.nil?
          user_involvement = I18n.t('user_involvement.not_registered_with_issues') if record.issue_present && record.patient&.id.nil?
          user_involvement = I18n.t('user_involvement.registered_without_issues') if !record.issue_present && record.patient&.id.present?
          user_involvement = I18n.t('user_involvement.registered_with_issues') if record.issue_present && record.patient&.id.present?

          user_involvement
        else
          value = record.send(col)
          if value == true
            1
          elsif value == false
            0
          else
            value
          end
        end
      end
      sheet.row(row_index).concat(row_values)
      row_index += 1
    end

    spreadsheet_stream = StringIO.new
    book.write(spreadsheet_stream)

    spreadsheet_stream
  end
end
