import { z } from 'zod';
import * as m from '$paraglide/messages';

export const forgotPasswordFormSchema = z.object({
  email: z.string().email({ message: m.invalidEmail() }).min(1, { message: m.fieldIsRequired() }),
});

export type ForgotPasswordFormSchema = typeof forgotPasswordFormSchema;
export type ForgotPasswordFormSchemaTypes = z.infer<typeof forgotPasswordFormSchema>;
