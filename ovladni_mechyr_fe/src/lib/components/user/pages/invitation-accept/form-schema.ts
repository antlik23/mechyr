import { z } from 'zod';
import * as m from '$paraglide/messages';

export const invitationAcceptFormSchema = z
  .object({
    email: z.string().email({ message: m.fieldIsRequired() }),
    full_name: z.string().min(1, { message: m.fieldIsRequired() }),
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

export type InvitationAcceptFormSchema = typeof invitationAcceptFormSchema;
export type InvitationAcceptFormSchemaTypes = z.infer<InvitationAcceptFormSchema>;
