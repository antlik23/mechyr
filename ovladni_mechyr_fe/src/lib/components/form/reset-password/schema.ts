import { z } from 'zod';
import * as m from '$paraglide/messages';

export const resetPasswordFormSchema = z
  .object({
    password: z
      .string({ message: m.fieldIsRequired() })
      .min(6, { message: m.fieldMinimumLengthIsX({ minimumAmount: 6 }) }),
    password_confirmation: z
      .string({ message: m.fieldIsRequired() })
      .min(6, { message: m.fieldMinimumLengthIsX({ minimumAmount: 6 }) }),
  })
  .superRefine((formData, ctx) => {
    if (
      formData.password.length > 0 &&
      formData.password_confirmation.length > 0 &&
      formData.password !== formData.password_confirmation
    ) {
      ctx.addIssue({
        path: ['password_confirmation'],
        message: m.passwordsMustMatch(),
        code: z.ZodIssueCode.custom,
      });
    }
  });

export type ResetPasswordFormSchema = typeof resetPasswordFormSchema;
export type ResetPasswordFormSchemaTypes = z.infer<typeof resetPasswordFormSchema>;
