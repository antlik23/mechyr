import * as m from '$paraglide/messages';
import { z } from 'zod';
import { DIAGNOSES, DOSAGE_UNITS, PRESCRIBED_MEDICATIONS } from '../initial-appointment/constants';
import { REASONS_TREATMENT_NOT_STARTED } from './constants';
import { GENDERS } from '$lib/components/user/genders';

export const firstAppointmentFormSchema = z
  .object({
    appointment_date: z.string().date(m.fieldIsRequired()),
    consent_signed: z.boolean({ message: m.fieldIsRequired() }),
    meets_project_criteria: z.union([z.boolean(), z.string()]),
    blood_in_urine: z.boolean().optional(),
    protein_in_urine: z.boolean().optional(),
    sugar_in_urine: z.boolean().optional(),
    post_void_residual_over_100_ml: z.boolean().optional(),
    clinical_assessment_completed: z.union([z.boolean(), z.string()]),
    prolapse_present: z.union([z.boolean(), z.string()]),
    stress_test_done: z.union([z.boolean(), z.string()]),
    stress_test_result: z.union([z.boolean(), z.string()]),
    uti_excluded: z.union([z.boolean(), z.string()]),
    bladder_discomfort_vas: z.union([z.number(), z.string()]),
    diagnosis: z.enum([...DIAGNOSES, ''] as const),
    alternative_diagnosis: z.string(),
    oab_treatment_criteria_met: z.union([z.boolean(), z.string()]),
    prescribed_medication: z.enum([...PRESCRIBED_MEDICATIONS, ''] as const),
    dosage: z.union([z.number(), z.string()]),
    dosage_unit: z.enum([...DOSAGE_UNITS, ''] as const),
    alternative_dosage_unit: z.string(),
    reason_treatment_not_started: z.enum([...REASONS_TREATMENT_NOT_STARTED, ''] as const),
    alternative_treatment_details: z.string(),
    treatment_contraindications: z.string(),
    follow_up_date: z.string(),
    notes: z.string().optional(),
  })
  .extend({
    gender: z.enum([GENDERS['0'], GENDERS['1'], GENDERS['2']]).nullable(),
  })
  .superRefine((formData, ctx) => {
    if (formData.consent_signed) {
      if (typeof formData.meets_project_criteria !== 'boolean') {
        ctx.addIssue({
          path: ['meets_project_criteria'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      } else {
        if (formData.meets_project_criteria) {
          if (typeof formData.clinical_assessment_completed !== 'boolean') {
            ctx.addIssue({
              path: [
                'clinical_assessment_completed',
              ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else {
            if (formData.clinical_assessment_completed) {
              if (typeof formData.prolapse_present !== 'boolean' && formData.gender === 'female') {
                ctx.addIssue({
                  path: ['prolapse_present'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                  message: m.fieldIsRequired(),
                  code: z.ZodIssueCode.custom,
                });
              }
            }
          }

          if (typeof formData.stress_test_done !== 'boolean') {
            ctx.addIssue({
              path: ['stress_test_done'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else {
            if (formData.stress_test_done) {
              if (typeof formData.stress_test_result !== 'boolean') {
                ctx.addIssue({
                  path: ['stress_test_result'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                  message: m.fieldIsRequired(),
                  code: z.ZodIssueCode.custom,
                });
              }
            }
          }

          if (typeof formData.uti_excluded !== 'boolean') {
            ctx.addIssue({
              path: ['uti_excluded'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          }

          if (formData.bladder_discomfort_vas === '') {
            ctx.addIssue({
              path: ['bladder_discomfort_vas'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else if (typeof formData.bladder_discomfort_vas === 'number') {
            if (formData.bladder_discomfort_vas < 0) {
              ctx.addIssue({
                path: [
                  'bladder_discomfort_vas',
                ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                message: m.fieldMinimumLengthIsX({ minimumAmount: 0 }),
                code: z.ZodIssueCode.custom,
              });
            } else if (formData.bladder_discomfort_vas > 10) {
              ctx.addIssue({
                path: [
                  'bladder_discomfort_vas',
                ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                message: m.fieldMustBeMax({ maxAmount: 10 }),
                code: z.ZodIssueCode.custom,
              });
            }
          }

          if (formData.diagnosis === '') {
            ctx.addIssue({
              path: ['diagnosis'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          } else if (formData.diagnosis === 'other_diagnosis') {
            if (formData.alternative_diagnosis.length === 0) {
              ctx.addIssue({
                path: ['alternative_diagnosis'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
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
                ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            } else {
              if (formData.oab_treatment_criteria_met) {
                if (formData.prescribed_medication === '') {
                  ctx.addIssue({
                    path: [
                      'prescribed_medication',
                    ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                    message: m.fieldIsRequired(),
                    code: z.ZodIssueCode.custom,
                  });
                }

                if (formData.dosage === '') {
                  ctx.addIssue({
                    path: ['dosage'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
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

                if (formData.dosage_unit === '') {
                  ctx.addIssue({
                    path: ['dosage_unit'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                    message: m.fieldIsRequired(),
                    code: z.ZodIssueCode.custom,
                  });
                } else if (formData.dosage_unit === 'other_unit') {
                  if (formData.alternative_dosage_unit.length === 0) {
                    ctx.addIssue({
                      path: [
                        'alternative_dosage_unit',
                      ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                      message: m.fieldIsRequired(),
                      code: z.ZodIssueCode.custom,
                    });
                  }
                }
              } else if (formData.oab_treatment_criteria_met === false) {
                if (formData.reason_treatment_not_started === '') {
                  ctx.addIssue({
                    path: [
                      'reason_treatment_not_started',
                    ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                    message: m.fieldIsRequired(),
                    code: z.ZodIssueCode.custom,
                  });
                } else if (formData.reason_treatment_not_started === 'other_treatment') {
                  if (formData.alternative_treatment_details === '') {
                    ctx.addIssue({
                      path: [
                        'alternative_treatment_details',
                      ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                      message: m.fieldIsRequired(),
                      code: z.ZodIssueCode.custom,
                    });
                  }
                } else if (
                  formData.reason_treatment_not_started === 'contraindications_to_treatment'
                ) {
                  if (formData.treatment_contraindications === '') {
                    ctx.addIssue({
                      path: [
                        'treatment_contraindications',
                      ] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                      message: m.fieldIsRequired(),
                      code: z.ZodIssueCode.custom,
                    });
                  }
                }
              }
            }

            if (formData.follow_up_date === '') {
              ctx.addIssue({
                path: ['follow_up_date'] satisfies (keyof FirstAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }
          }
        }
      }
    }
  });

export type FirstAppointmentFormSchema = typeof firstAppointmentFormSchema;
export type FirstAppointmentFormSchemaTypes = z.infer<FirstAppointmentFormSchema>;
