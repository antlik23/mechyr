import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

export type PrescribedMedication = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_seconds']['post']
  >['appointment_second']['prescribed_medication']
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
  'multiple_medication',
  'other',
] as const satisfies PrescribedMedication[];
assert<Equals<(typeof PRESCRIBED_MEDICATIONS)[number], PrescribedMedication>>();
assert<Equals<IsUnique<typeof PRESCRIBED_MEDICATIONS>, true>>();

const prescribedMedicationNames: Record<PrescribedMedication, () => string> = {
  oxybutynin: () => 'Oxybutynin',
  tolterodin: () => 'Tolterodin',
  darifenacin: () => 'Darifenacin',
  solifenacin: () => 'Solifenacin',
  trospium_chlorid: () => 'Trospium chlorid',
  fesoterodin: () => 'Fesoterodin',
  mirabegron: () => 'Mirabegron',
  propiverin: () => 'Propiverin',
  multiple_medication: () => 'Kombinace léků',
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

export type DiscontinuationReason = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_seconds']['post']
  >['appointment_second']['discontinuation_reason']
>;

export const DISCONTINUATION_REASONS = [
  'adverse_effects',
  'treatment_ineffectiveness',
  'other_reason',
] as const satisfies DiscontinuationReason[];
assert<Equals<(typeof DISCONTINUATION_REASONS)[number], DiscontinuationReason>>();
assert<Equals<IsUnique<typeof DISCONTINUATION_REASONS>, true>>();

// TODO: move to paraglide messages
const discontinuationReasonNames: Record<DiscontinuationReason, () => string> = {
  adverse_effects: () => 'Výskyt nežádoucích účinků',
  treatment_ineffectiveness: () => 'Neúčinnost léčby',
  other_reason: m.other,
} as const;

export function getDiscontinuationReasonsList() {
  return DISCONTINUATION_REASONS.map((discontinuationReason) => ({
    value: discontinuationReason,
    label: getDiscontinuationReasonName(discontinuationReason),
  }));
}

export function getDiscontinuationReasonName(discontinuationReason: DiscontinuationReason) {
  return discontinuationReasonNames[discontinuationReason]?.() ?? discontinuationReason;
}

export type CurrentTreatment = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_seconds']['post']
  >['appointment_second']['current_treatment']
>;

export const CURRENT_TREATMENTS = [
  'same_dose',
  'higher_dose',
  'combination',
  'change_of_medication',
] as const satisfies CurrentTreatment[];
assert<Equals<(typeof CURRENT_TREATMENTS)[number], CurrentTreatment>>();
assert<Equals<IsUnique<typeof CURRENT_TREATMENTS>, true>>();

// TODO: move to paraglide messages
const currentTreatmentNames: Record<CurrentTreatment, () => string> = {
  same_dose: () => 'Stejná dávka',
  higher_dose: () => 'Vyšší dávka',
  combination: () => 'Kombinace',
  change_of_medication: () => 'Změna léku',
} as const;

export function getCurrentTreatmentsList() {
  return CURRENT_TREATMENTS.map((currentTreatment) => ({
    value: currentTreatment,
    label: getCurrentTreatmentName(currentTreatment),
  }));
}

export function getCurrentTreatmentName(currentTreatment: CurrentTreatment) {
  return currentTreatmentNames[currentTreatment]?.() ?? currentTreatment;
}
