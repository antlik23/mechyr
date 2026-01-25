# frozen_string_literal: true

module Enums
  DIAGNOSIS = {
    without_oab: 0,
    oab: 1,
    oab_wet: 2,
    oab_mixed_incontinence: 3,
    unable_to_assess: 4,
    other_diagnosis: 5
  }.freeze

  PRESCRIBED_MEDICATION = {
    oxybutynin: 0,
    tolterodin: 1,
    darifenacin: 2,
    solifenacin: 3,
    trospium_chlorid: 4,
    fesoterodin: 5,
    mirabegron: 6,
    propiverin: 7,
    other: 8
  }.freeze

  PRESCRIBED_MEDICATION_SECOND = {
    oxybutynin: 0,
    tolterodin: 1,
    darifenacin: 2,
    solifenacin: 3,
    trospium_chlorid: 4,
    fesoterodin: 5,
    mirabegron: 6,
    propiverin: 7,
    multiple_medication: 8,
    other: 9
  }.freeze

  DOSAGE_UNIT = {
    mg: 0,
    ml: 1,
    other_unit: 2
  }.freeze

  REASON_TREATMENT_NOT_STARTED = {
    other_treatment: 0,
    unable_to_propose_treatment: 1,
    no_therapy_needed: 2,
    contraindications_to_treatment: 3,
    patient_refused_treatment: 4
  }.freeze

  REASON_TREATMENT_NOT_STARTED_INITIAL = {
    other_treatment: 0,
    unable_to_propose_treatment: 1,
    no_therapy_needed: 2
  }.freeze

  DISCONTINUATION_REASON = {
    adverse_effects: 0,
    treatment_ineffectiveness: 1,
    other_reason: 2
  }.freeze

  CURRENT_TREATMENT = {
    same_dose: 0,
    higher_dose: 1,
    combination: 2,
    change_of_medication: 3
  }.freeze

  CONTINUING_TREATMENT = {
    false: 0,
    true: 1,
    without_oab: 2
  }.freeze
end
