import { z } from 'zod';
import { differenceInDays } from 'date-fns';
import * as m from '$paraglide/messages';

export const voidingDiaryFormSchema = z
  .object({
    diary_start_date: z
      .string()
      .date(m.fieldIsRequired())
      .refine((value) => differenceInDays(new Date(value), new Date()) < 0, {
        message: m.fieldMustBeInPast(),
      }),
    diary_duration_days: z.number({ message: m.fieldIsRequired() }),
    bedtime_day_one: z.string().time({ message: m.fieldIsRequired() }),
    wake_up_time_day_one: z.string().time({ message: m.fieldIsRequired() }),
    bedtime_day_two: z.string().time({ message: m.fieldIsRequired() }),
    wake_up_time_day_two: z.string().time({ message: m.fieldIsRequired() }),
    completed: z.boolean().default(false),
  })
  .superRefine((formData, ctx) => {
    if (
      formData.diary_start_date &&
      formData.diary_duration_days &&
      differenceInDays(new Date(formData.diary_start_date), new Date()) >
        -1 * formData.diary_duration_days
    ) {
      ctx.addIssue({
        path: ['diary_duration_days'] satisfies (keyof VoidingDiaryFormSchemaTypes)[],
        message: m.diaryMustEndInPast(),
        code: z.ZodIssueCode.custom,
      });
    }
  });

export type VoidingDiaryFormSchema = typeof voidingDiaryFormSchema;
export type VoidingDiaryFormSchemaTypes = z.infer<VoidingDiaryFormSchema>;
