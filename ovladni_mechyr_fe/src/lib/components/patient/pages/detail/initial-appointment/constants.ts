import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

export type Diagnosis = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_initials']['post']
  >['appointment_initial']['diagnosis']
>;

export const DIAGNOSES = [
  'without_oab',
  'oab',
  'oab_wet',
  'oab_mixed_incontinence',
  'unable_to_assess',
  'other_diagnosis',
] as const satisfies Diagnosis[];
assert<Equals<(typeof DIAGNOSES)[number], Diagnosis>>();
assert<Equals<IsUnique<typeof DIAGNOSES>, true>>();

// TODO: move to paraglide messages
const diagnosisNames: Record<Diagnosis, () => string> = {
  without_oab: () => 'Bez OAB',
  oab: () => 'OAB',
  oab_wet: () => 'OAB wet',
  oab_mixed_incontinence: () => 'Smíšená inkontinence moči',
  unable_to_assess: () => 'Nedokážu posoudit',
  other_diagnosis: () => `${m.other()} (např. stresová inkontinence)`,
} as const;

export function getDiagnosesList() {
  return DIAGNOSES.map((diagnosis) => ({
    value: diagnosis,
    label: getTranslatedDiagnosisName(diagnosis),
  }));
}

export function getTranslatedDiagnosisName(diagnosis: Diagnosis) {
  return diagnosisNames[diagnosis]?.() ?? diagnosis;
}

export type PrescribedMedication = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_initials']['post']
  >['appointment_initial']['prescribed_medication']
>;

export const PRESCRIBED_MEDICATIONS = [
  'oxybutynin',
  'tolterodin',
  'darifenacin',
  'solifenacin',
  'trospium_chlorid',
  'fesoterodin',
  'mirabegron',
  'propiverin',
  'other',
] as const satisfies PrescribedMedication[];
assert<Equals<(typeof PRESCRIBED_MEDICATIONS)[number], PrescribedMedication>>();
assert<Equals<IsUnique<typeof PRESCRIBED_MEDICATIONS>, true>>();

// TODO: move to paraglide messages
const prescribedMedicationNames: Record<PrescribedMedication, () => string> = {
  oxybutynin: () => 'Oxybutynin',
  tolterodin: () => 'Tolterodin',
  darifenacin: () => 'Darifenacin',
  solifenacin: () => 'Solifenacin',
  trospium_chlorid: () => 'Trospium chlorid',
  fesoterodin: () => 'Fesoterodin',
  mirabegron: () => 'Mirabegron',
  propiverin: () => 'Propiverin',
  other: () => 'Jiné',
} as const;

export function getPrescribedMedicationsList() {
  return PRESCRIBED_MEDICATIONS.map((prescribedMedication) => ({
    value: prescribedMedication,
    label: getTranslatedPrescribedMedicationName(prescribedMedication),
  }));
}

export function getTranslatedPrescribedMedicationName(prescribedMedication: PrescribedMedication) {
  return prescribedMedicationNames[prescribedMedication]?.() ?? prescribedMedication;
}

export type ReasonTreatmentNotStarted = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_initials']['post']
  >['appointment_initial']['reason_treatment_not_started']
>;

export const REASONS_TREATMENT_NOT_STARTED = [
  'other_treatment',
  'unable_to_propose_treatment',
  'no_therapy_needed',
] as const satisfies ReasonTreatmentNotStarted[];
assert<Equals<(typeof REASONS_TREATMENT_NOT_STARTED)[number], ReasonTreatmentNotStarted>>();
assert<Equals<IsUnique<typeof REASONS_TREATMENT_NOT_STARTED>, true>>();

// TODO: move to paraglide messages
const reasonTreatmentNotStartedNames: Record<ReasonTreatmentNotStarted, () => string> = {
  other_treatment: () => 'Jiná léčba',
  unable_to_propose_treatment: () => 'Nedokážu navrhnout léčbu',
  no_therapy_needed: () => 'Není nutná terapie',
} as const;

export function getReasonsTreatmentNotStartedList() {
  return REASONS_TREATMENT_NOT_STARTED.map((reasonTreatmentNotStarted) => ({
    value: reasonTreatmentNotStarted,
    label: getTranslatedReasonTreatmentNotStartedName(reasonTreatmentNotStarted),
  }));
}

export function getTranslatedReasonTreatmentNotStartedName(
  reasonTreatmentNotStarted: ReasonTreatmentNotStarted
) {
  return reasonTreatmentNotStartedNames[reasonTreatmentNotStarted]?.() ?? reasonTreatmentNotStarted;
}

export type DosageUnit = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_initials']['post']
  >['appointment_initial']['dosage_unit']
>;

export const DOSAGE_UNITS = ['mg', 'ml', 'other_unit'] as const satisfies DosageUnit[];
assert<Equals<(typeof DOSAGE_UNITS)[number], DosageUnit>>();
assert<Equals<IsUnique<typeof DOSAGE_UNITS>, true>>();

// TODO: move to paraglide messages
const dosageUnitNames: Record<DosageUnit, () => string> = {
  mg: () => 'mg',
  ml: () => 'ml',
  other_unit: m.other,
} as const;

export function getDosageUnitsList() {
  return DOSAGE_UNITS.map((dosageUnit) => ({
    value: dosageUnit,
    label: getTranslatedDosageUnitName(dosageUnit),
  }));
}

export function getTranslatedDosageUnitName(dosageUnit: DosageUnit) {
  return dosageUnitNames[dosageUnit]?.() ?? dosageUnit;
}
