import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import { assert, type Equals } from 'tsafe';

export type ReasonTreatmentNotStarted = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/appointment_firsts']['post']
  >['appointment_first']['reason_treatment_not_started']
>;

export const REASONS_TREATMENT_NOT_STARTED = [
  'other_treatment',
  'unable_to_propose_treatment',
  'no_therapy_needed',
  'contraindications_to_treatment',
  'patient_refused_treatment',
] as const satisfies ReasonTreatmentNotStarted[];
assert<Equals<(typeof REASONS_TREATMENT_NOT_STARTED)[number], ReasonTreatmentNotStarted>>();
assert<Equals<IsUnique<typeof REASONS_TREATMENT_NOT_STARTED>, true>>();

// TODO: move to paraglide messages
const reasonTreatmentNotStartedNames: Record<ReasonTreatmentNotStarted, () => string> = {
  other_treatment: () => 'Jiná léčba',
  unable_to_propose_treatment: () => 'Nedokážu navrhnout léčbu',
  no_therapy_needed: () => 'Není nutná terapie',
  contraindications_to_treatment: () => 'Kontraindikace k léčbě',
  patient_refused_treatment: () => 'Pacient si nepřeje farmakoterapii',
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
