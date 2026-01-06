import { z } from 'zod';
import * as m from '$paraglide/messages';
import { GENDERS } from '$lib/components/user/genders';

const ageMinimum = 18;
const ageMaximum = 200;

const heightMinimum = 50;
const heightMaximum = 400;

const weightMinimum = 20;
const weightMaximum = 800;

const birthsMaximum = 30;

export const anamnesticFormSchema = z
  .discriminatedUnion('gender', [
    z.object({
      gender: z.enum([GENDERS['1']]),
      number_of_births: z
        .number({ message: m.fieldIsRequired() })
        .nonnegative(m.fieldCantBeNegativeNumber())
        .max(birthsMaximum, { message: m.fieldMustBeMax({ maxAmount: birthsMaximum }) }),
      post_menopausal: z.boolean({ message: m.fieldIsRequired() }),
      prolapse_diagnosed: z.boolean({ message: m.fieldIsRequired() }),
      hysterectomy: z.boolean({ message: m.fieldIsRequired() }),
      cesarean_section: z.enum(['true', 'false', 'no_birth'] as const),
      surgery_for_benign_prostate_enlargement: z.boolean().optional(),
      surgery_for_prostate_cancer: z.boolean().optional(),
      surgery_for_bladder_tumor: z.boolean().optional(),
      surgery_for_urethral_stricture: z.boolean().optional(),
      surgery_for_urine_leakage: z.boolean().optional(),
      other_surgery: z.boolean().optional(),
      no_surgery: z.boolean().optional(),
      neurological_surgery_history: z.boolean({ message: m.fieldIsRequired() }),
    }),
    z.object({
      gender: z.enum([GENDERS['0']]),
      number_of_births: z.undefined(),
      post_menopausal: z.undefined(),
      prolapse_diagnosed: z.undefined(),
      hysterectomy: z.undefined(),
      cesarean_section: z.undefined(),
      surgery_for_benign_prostate_enlargement: z.boolean().default(false),
      surgery_for_prostate_cancer: z.boolean().default(false),
      surgery_for_bladder_tumor: z.boolean().default(false),
      surgery_for_urethral_stricture: z.boolean().default(false),
      surgery_for_urine_leakage: z.boolean().default(false),
      other_surgery: z.boolean().default(false),
      no_surgery: z.boolean().default(false),
      neurological_surgery_history: z.undefined(),
    }),
  ])
  .and(
    z.object({
      age: z
        .number({ message: m.fieldIsRequired() })
        .min(ageMinimum, { message: m.fieldMustBeMin({ minAmount: ageMinimum }) })
        .max(ageMaximum, { message: m.fieldMustBeMax({ maxAmount: ageMaximum }) }),
      height: z
        .number({ message: m.fieldIsRequired() })
        .min(heightMinimum, { message: m.fieldMustBeMin({ minAmount: heightMinimum }) })
        .max(heightMaximum, { message: m.fieldMustBeMax({ maxAmount: heightMaximum }) }),
      weight: z
        .number({ message: m.fieldIsRequired() })
        .min(weightMinimum, { message: m.fieldMustBeMax({ maxAmount: weightMinimum }) })
        .max(weightMaximum, { message: m.fieldMustBeMax({ maxAmount: weightMaximum }) }),
      on_oab_medication_last_3_months: z.boolean({ message: m.fieldIsRequired() }),
      previous_surgery_details: z.string(),
      recurrent_infections: z.boolean({ message: m.fieldIsRequired() }),
      hypertension: z.boolean().default(false),
      hypothyroidism: z.boolean().default(false),
      high_cholesterol: z.boolean().default(false),
      diabetes: z.boolean().default(false),
      back_problems: z.boolean().default(false),
      depression: z.boolean().default(false),
      other_psychiatric_conditions: z.boolean().default(false),
      reduced_immunity: z.boolean().default(false),
      headaches: z.boolean().default(false),
      hip_osteoarthritis: z.boolean().default(false),
      knee_osteoarthritis: z.boolean().default(false),
      no_illness: z.boolean().default(false),
      cancer_treatment_history: z.boolean({ message: m.fieldIsRequired() }),
      cervical_cancer: z.boolean().default(false),
      endometrial_cancer: z.boolean().default(false),
      ovarian_cancer: z.boolean().default(false),
      breast_cancer: z.boolean().default(false),
      intestinal_cancer: z.boolean().default(false),
      other_cancer: z.boolean().default(false),
      cancer_type_details: z.string(),
      drug_allergies: z.boolean({ message: m.fieldIsRequired() }),
      drug_allergies_details: z.string(),
      glaucoma_or_eye_pressure_meds: z.boolean({ message: m.fieldIsRequired() }),
      cardiac_conditions: z.boolean({ message: m.fieldIsRequired() }),
      heart_attack: z.boolean({ message: m.fieldIsRequired() }),
      arrhythmia: z.boolean({ message: m.fieldIsRequired() }),
      stroke: z.boolean({ message: m.fieldIsRequired() }),
      digestive_problems: z.boolean({ message: m.fieldIsRequired() }),
      dry_mucous_membranes: z.boolean({ message: m.fieldIsRequired() }),
      current_medications: z.boolean({ message: m.fieldIsRequired() }),
      current_medications_details: z.string(),
      past_medications: z.boolean({ message: m.fieldIsRequired() }),
      past_medications_details: z.string(),
    })
  )
  .superRefine((formData, ctx) => {
    if (formData.other_surgery && formData.previous_surgery_details.length === 0) {
      ctx.addIssue({
        path: ['previous_surgery_details'] satisfies (keyof AnamnesticFormSchemaTypes)[],
        message: m.fieldIsRequired(),
        code: z.ZodIssueCode.custom,
      });
    }

    if (formData.other_cancer && formData.cancer_type_details.length === 0) {
      ctx.addIssue({
        path: ['cancer_type_details'] satisfies (keyof AnamnesticFormSchemaTypes)[],
        message: m.fieldIsRequired(),
        code: z.ZodIssueCode.custom,
      });
    }

    if (formData.drug_allergies && formData.drug_allergies_details.length === 0) {
      ctx.addIssue({
        path: ['drug_allergies_details'] satisfies (keyof AnamnesticFormSchemaTypes)[],
        message: m.fieldIsRequired(),
        code: z.ZodIssueCode.custom,
      });
    }

    if (formData.current_medications && formData.current_medications_details.length === 0) {
      ctx.addIssue({
        path: ['current_medications_details'] satisfies (keyof AnamnesticFormSchemaTypes)[],
        message: m.fieldIsRequired(),
        code: z.ZodIssueCode.custom,
      });
    }

    if (formData.past_medications && formData.past_medications_details.length === 0) {
      ctx.addIssue({
        path: ['past_medications_details'] satisfies (keyof AnamnesticFormSchemaTypes)[],
        message: m.fieldIsRequired(),
        code: z.ZodIssueCode.custom,
      });
    }
  });

export type AnamnesticFormSchema = typeof anamnesticFormSchema;
export type AnamnesticFormSchemaTypes = z.infer<AnamnesticFormSchema>;
