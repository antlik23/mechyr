import { z } from 'zod';
import * as m from '$paraglide/messages';
import { BEVERAGE_TYPE } from './constants';

const fluidIntakeMaximum = 15_000;

export const voidingDiaryRecordInputFormSchema = z.object({
  recorded_at: z.string().date(m.fieldIsRequired()),
  recordedAtTime: z.string().time({ message: m.fieldIsRequired() }),
  beverage_type: z.enum(BEVERAGE_TYPE, { message: m.fieldIsRequired() }),
  fluid_intake: z
    .number({ message: m.fieldIsRequired() })
    .positive({ message: m.fieldMustBePositiveNumber() })
    .max(fluidIntakeMaximum, { message: m.fieldMustBeMax({ maxAmount: fluidIntakeMaximum }) }),
});

export type VoidingDiaryRecordInputFormSchema = typeof voidingDiaryRecordInputFormSchema;
export type VoidingDiaryRecordInputFormSchemaTypes = z.infer<VoidingDiaryRecordInputFormSchema>;
