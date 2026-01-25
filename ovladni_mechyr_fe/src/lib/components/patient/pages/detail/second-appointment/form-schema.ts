import * as m from '$paraglide/messages';
import { z } from 'zod';
import { DOSAGE_UNITS } from '../initial-appointment/constants';
import { CURRENT_TREATMENTS, DISCONTINUATION_REASONS, PRESCRIBED_MEDICATIONS } from './constants';

export const secondAppointmentFormSchema = z
  .object({
    attended_appointment: z.boolean({ message: m.fieldIsRequired() }),
    appointment_date: z.union([z.literal(''), z.string().date(m.fieldIsRequired())]),
    visual_analog_scale: z.union([z.number(), z.string()]),
    continuing_treatment: z.enum([...['without_oab', 'true', 'false'], ''] as const),
    discontinuation_reason: z.enum([...DISCONTINUATION_REASONS, ''] as const),
    alternative_reason: z.string(),
    current_treatment: z.enum([...CURRENT_TREATMENTS, ''] as const),
    prescribed_medication: z.enum([...PRESCRIBED_MEDICATIONS, ''] as const),
    dosage: z.union([z.number(), z.string()]),
    dosage_unit: z.enum([...DOSAGE_UNITS, ''] as const),
    alternative_dosage_unit: z.string(),
    multiple_medications: z.string(),
    multiple_medications_dosage: z.string(),
    notes: z.string().optional(),
  })
  .superRefine((formData, ctx) => {
    if (formData.attended_appointment) {
      if (formData.appointment_date === '') {
        ctx.addIssue({
          path: ['appointment_date'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      }

      if (formData.visual_analog_scale === '') {
        ctx.addIssue({
          path: ['visual_analog_scale'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      } else if (typeof formData.visual_analog_scale === 'number') {
        if (formData.visual_analog_scale < 0) {
          ctx.addIssue({
            path: ['visual_analog_scale'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
            message: m.fieldMinimumLengthIsX({ minimumAmount: 0 }),
            code: z.ZodIssueCode.custom,
          });
        } else if (formData.visual_analog_scale > 10) {
          ctx.addIssue({
            path: ['visual_analog_scale'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
            message: m.fieldMustBeMax({ maxAmount: 10 }),
            code: z.ZodIssueCode.custom,
          });
        }
      }

      if (formData.continuing_treatment === '') {
        ctx.addIssue({
          path: ['continuing_treatment'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
          message: m.fieldIsRequired(),
          code: z.ZodIssueCode.custom,
        });
      }

      if (formData.continuing_treatment === 'false') {
        if (formData.discontinuation_reason === '') {
          ctx.addIssue({
            path: ['discontinuation_reason'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
            message: m.fieldIsRequired(),
            code: z.ZodIssueCode.custom,
          });
        }

        if (formData.discontinuation_reason === 'other_reason') {
          if (formData.alternative_reason === '') {
            ctx.addIssue({
              path: ['alternative_reason'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          }
        }
      } else if (formData.continuing_treatment === 'true') {
        if (formData.current_treatment === '') {
          ctx.addIssue({
            path: ['current_treatment'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
            message: m.fieldIsRequired(),
            code: z.ZodIssueCode.custom,
          });
        }

        if (formData.current_treatment === 'change_of_medication') {
          if (formData.prescribed_medication === '') {
            ctx.addIssue({
              path: ['prescribed_medication'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
              message: m.fieldIsRequired(),
              code: z.ZodIssueCode.custom,
            });
          }

          if (formData.prescribed_medication !== 'multiple_medication') {
            if (formData.dosage === '') {
              ctx.addIssue({
                path: ['dosage'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
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
                path: ['dosage_unit'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }

            if (formData.dosage_unit === 'other_unit') {
              if (formData.alternative_dosage_unit === '') {
                ctx.addIssue({
                  path: [
                    'alternative_dosage_unit',
                  ] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
                  message: m.fieldIsRequired(),
                  code: z.ZodIssueCode.custom,
                });
              }
            }
          }

          if (formData.prescribed_medication === 'multiple_medication') {
            if (formData.multiple_medications === '') {
              ctx.addIssue({
                path: ['multiple_medications'] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }

            if (formData.multiple_medications_dosage === '') {
              ctx.addIssue({
                path: [
                  'multiple_medications_dosage',
                ] satisfies (keyof SecondAppointmentFormSchemaTypes)[],
                message: m.fieldIsRequired(),
                code: z.ZodIssueCode.custom,
              });
            }
          }
        }
      }
    }
  });

export type SecondAppointmentFormSchema = typeof secondAppointmentFormSchema;
export type SecondAppointmentFormSchemaTypes = z.infer<SecondAppointmentFormSchema>;
