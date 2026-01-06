# frozen_string_literal: true

module CsvExportEnums
  class << self
    def gender(value)
      mapping = {
        'male' => 'muz',
        'female' => 'zena',
        'with_prostate' => 'ostatni s prostatou',
        'without_prostate' => 'ostatni bez prostaty'
      }
      mapping[value]
    end

    def ipss_form(value)
      mapping = {
        1 => 'Asi v jednom z 5 pripadu',
        2 => 'V mene nez polovine pripadu',
        3 => 'Asi v polovine pripadu',
        4 => 'Ve vice nez polovine pripadu',
        5 => 'Temer vzdy',
        0 => 'Vubec ne'
      }
      mapping[value]
    end

    def oab_form(value)
      mapping = {
        1 => 'Velmi malo',
        2 => 'Trochu vice',
        3 => 'Docela ano',
        4 => 'Hodne',
        5 => 'Opravdu hodne',
        0 => 'Vubec'
      }
      mapping[value]
    end

    def leakage_frequency(value)
      mapping = {
        1 => 'Asi jednou tydne nebo mene casto',
        2 => 'Dvakrat nebo trikrat tydne',
        3 => 'Asi jednou za den',
        4 => 'Nekolikrat denne',
        5 => 'Stale',
        0 => 'Nikdy'
      }
      mapping[value]
    end

    def leakage_assessment(record)
      mapping = {
        1 => 'Male mnozstvi',
        2 => 'Stredne velke mnozstvi',
        3 => 'Velke mnozstvi',
        0 => 'Zadne'
      }
      mapping[record]
    end

    def quality_of_life_evaluation(record)
      mapping = {
        1 => 'Dobre',
        2 => 'Prevazne dobre',
        3 => 'Stridave',
        4 => 'Prevazne spatne',
        5 => 'Spatne',
        6 => 'Nesnesitelne',
        0 => 'Vyborne'
      }
      mapping[record]
    end

    def nocturnal_urination(record)
      case record
      when 0
        'Nikdy'
      when 5
        '5x nebo vicekrat'
      else
        record
      end
    end

    def diagnosis(record)
      mapping = {
        'without_oab' => 'Bez OAB',
        'oab' => 'OAB',
        'oab_wet' => 'OAB wet',
        'oab_mixed_incontinence' => 'Smisena inkontinence moci',
        'unable_to_assess' => 'Nedokazu posoudit',
        'other_diagnosis' => 'Jiné (např. stresová inkontinence)'
      }
      mapping[record]
    end

    def reason_treatment_not_started(record)
      mapping = {
        'unable_to_propose_treatment' => 'Nedokazu navrhnout lecbu',
        'no_therapy_needed' => 'Neni nutna terapie',
        'contraindications_to_treatment' => 'Kontraindikace k lecbe',
        'other_treatment' => 'Jina lecba'
      }
      mapping[record]
    end

    def discontinuation_reason(record)
      mapping = {
        'adverse_effects' => 'Vyskyt nezadoucich ucinku',
        'treatment_ineffectiveness' => 'Neucinnost lecby',
        'other_reason' => 'Jine'
      }
      mapping[record]
    end

    def current_treatment(record)
      mapping = {
        'same_dose' => 'Stejna davka',
        'higher_dose' => 'Vyssi davka',
        'combination' => 'Kombinace',
        'change_of_medication' => 'Zmena leku'
      }
      mapping[record]
    end

    def dosage_unit(record)
      mapping = {
        'mg' => 'mg',
        'ml' => 'ml',
        'other_unit' => 'Jina jednotka'
      }
      mapping[record]
    end

    def prescribed_medication(record)
      mapping = {
        'oxybutynin' => 'Oxybutynin',
        'tolterodin' => 'Tolterodin',
        'darifenacin' => 'Darifenacin',
        'solifenacin' => 'Solifenacin',
        'trospium_chlorid' => 'Trospium chlorid',
        'fesoterodin' => 'Fesoterodin',
        'mirabegron' => 'Mirabegron',
        'propiverin' => 'Propiverin',
        'multiple_medication' => 'Kombinace léků',
        'other' => 'Jiné'
      }
      mapping[record]
    end

    def continuing_treatment(record)
      mapping = {
        'true' => 1,
        'false' => 0,
        'without_oab' => 'Bez OAB'
      }
      mapping[record]
    end

    def cesarean_section(record)
      mapping = {
        'true' => 1,
        'false' => 0,
        'without_oab' => 'V minulosti neproběhl žádný porod'
      }
      mapping[record]
    end
  end
end
