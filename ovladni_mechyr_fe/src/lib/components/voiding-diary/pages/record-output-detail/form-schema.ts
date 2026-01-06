import { z } from 'zod';
import * as m from '$paraglide/messages';
import { URINE_LEAKAGE_TYPE } from './constants';

const urineVolumeMaximum = 2_000;

export const voidingDiaryRecordOutputFormSchema = z
  .discriminatedUnion(
    'urine_leakage',
    [
      z.object({
        urine_leakage: z.literal(true, { message: m.fieldIsRequired() }),
        urine_leakage_type: z.enum(URINE_LEAKAGE_TYPE, { message: m.fieldIsRequired() }),
      }),
      z.object({
        urine_leakage: z.literal(false, { message: m.fieldIsRequired() }),
        urine_leakage_type: z.string().optional(),
      }),
    ],
    {
      errorMap: () => ({ message: m.fieldIsRequired() }),
    }
  )
  .and(
    z.object({
      recorded_at: z.string().date(m.fieldIsRequired()),
      recordedAtTime: z.string().time({ message: m.fieldIsRequired() }),
      slept_before_and_after: z.union([z.boolean(), z.string()]),
      urge_strength: z.number({ message: m.fieldIsRequired() }),
      urine_volume: z
        .number({ message: m.fieldIsRequired() })
        .positive(m.fieldMustBePositiveNumber())
        .max(urineVolumeMaximum, { message: m.fieldMustBeMax({ maxAmount: urineVolumeMaximum }) }),
    })
  );

export type VoidingDiaryRecordOutputFormSchema = typeof voidingDiaryRecordOutputFormSchema;
export type VoidingDiaryRecordOutputFormSchemaTypes = z.infer<VoidingDiaryRecordOutputFormSchema>;
