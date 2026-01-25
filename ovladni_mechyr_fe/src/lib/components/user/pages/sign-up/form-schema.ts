import { z } from 'zod';
import * as m from '$paraglide/messages.js';
import { GENDERS } from '$lib/components/user/genders';
import { PROSTATES } from '$lib/components/user/prostates';

export const signUpFormSchema = z
  .discriminatedUnion(
    'gender',
    [
      z.object({
        gender: z.enum([GENDERS['0'], GENDERS['1']], { message: m.fieldIsRequired() }),
        prostate: z.undefined(),
      }),
      z.object({
        gender: z.enum([GENDERS['2']], { message: m.fieldIsRequired() }),
        prostate: z.enum(PROSTATES, { message: m.fieldIsRequired() }),
      }),
    ],
    {
      errorMap: () => ({ message: m.fieldIsRequired() }),
    }
  )
  .and(
    z.object({
      email: z
        .string()
        .email({ message: m.invalidEmail() })
        .min(1, { message: m.fieldIsRequired() }),
      password: z
        .string({ message: m.fieldIsRequired() })
        .min(6, { message: m.fieldMinimumLengthIsX({ minimumAmount: 6 }) }),
      password_confirmation: z
        .string({ message: m.fieldIsRequired() })
        .min(6, { message: m.fieldMinimumLengthIsX({ minimumAmount: 6 }) }),
      consent: z.literal(true, {
        errorMap: () => ({ message: m.fieldIsRequired() }),
      }),
    })
  )
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

export type SignUpFormSchema = typeof signUpFormSchema;
export type SignUpFormSchemaTypes = z.infer<SignUpFormSchema>;
