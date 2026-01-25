import * as m from '$paraglide/messages';
import { z } from 'zod';
import {
  DIAGNOSES,
  DOSAGE_UNITS,
  PRESCRIBED_MEDICATIONS,
  REASONS_TREATMENT_NOT_STARTED,
} from './constants';

export const initialAppointmentFormSchema = z
  .object({
    assessment_date: z.string().date(m.fieldIsRequired()),
    diagnosis: z.enum(DIAGNOSES, { message: m.fieldIsRequired() }),
    alternative_diagnosis: z.string(),
    oab_treatment_criteria_met: z.union([z.boolean(), z.string()]),
    initiate_pharmacological_treatment: z.union([z.boolean(), z.string()]),
    prescribed_medication: z.enum([...PRESCRIBED_MEDICATIONS, ''] as const),
    dosage: z.union([z.number(), z.string()]),
    dosage_unit: z.enum([...DOSAGE_UNITS, ''] as const),
    alternative_dosage_unit: z.string(),
    reason_treatment_not_started: z.enum([...REASONS_TREATMENT_NOT_STARTED, ''] as const),
    alternative_treatment_details: z.string(),
  })
  .superRefine((formData, ctx) => {
    if (formData.diagnosis === 'other_diagnosis') {
      if (formData.alternative_diagnosis.length === 0) {
        ctx.addIssue({
          path: ['alternative_diagnosis'] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      }
    } else if (
      formData.diagnosis === 'oab' ||
      formData.diagnosis === 'oab_wet' ||
      formData.diagnosis === 'oab_mixed_incontinence' ||
      formData.diagnosis === 'unable_to_assess'
    ) {
      if (typeof formData.oab_treatment_criteria_met !== 'boolean') {
        ctx.addIssue({
          path: [
            'oab_treatment_criteria_met',
          ] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      }

      if (typeof formData.initiate_pharmacological_treatment !== 'boolean') {
        ctx.addIssue({
          path: [
            'initiate_pharmacological_treatment',
          ] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      } else {
        if (formData.initiate_pharmacological_treatment) {
          if (
            formData.prescribed_medication === '' ||
            !PRESCRIBED_MEDICATIONS.includes(formData.prescribed_medication)
          ) {
            ctx.addIssue({
              path: ['prescribed_medication'] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          }

          if (formData.dosage === '') {
            ctx.addIssue({
              path: ['dosage'] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else if (typeof formData.dosage === 'number') {
            if (formData.dosage < 1) {
              ctx.addIssue({
                path: ['dosage'],
                message: m.fieldMustBeMin({ minAmount: 1 }),
                code: z.ZodIssueCode.custom,
              });
            } else if (formData.dosage > 999) {
              ctx.addIssue({
                path: ['dosage'],
                message: m.fieldMustBeMax({ maxAmount: 999 }),
                code: z.ZodIssueCode.custom,
              });
            }
          }

          if (formData.dosage_unit === '' || !DOSAGE_UNITS.includes(formData.dosage_unit)) {
            ctx.addIssue({
              path: ['dosage_unit'] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else {
            if (
              formData.dosage_unit === 'other_unit' &&
              formData.alternative_dosage_unit.length === 0
            ) {
              ctx.addIssue({
                path: [
                  'alternative_dosage_unit',
                ] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }
          }
        } else {
          if (
            formData.reason_treatment_not_started === '' ||
            !REASONS_TREATMENT_NOT_STARTED.includes(formData.reason_treatment_not_started)
          ) {
            ctx.addIssue({
              path: [
                'reason_treatment_not_started',
              ] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else if (formData.reason_treatment_not_started === 'other_treatment') {
            if (formData.alternative_treatment_details.length === 0) {
              ctx.addIssue({
                path: [
                  'alternative_treatment_details',
                ] satisfies (keyof InitialAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }
          }
        }
      }
    }
  });

export type InitialAppointmentFormSchema = typeof initialAppointmentFormSchema;
export type InitialAppointmentFormSchemaTypes = z.infer<InitialAppointmentFormSchema>;
