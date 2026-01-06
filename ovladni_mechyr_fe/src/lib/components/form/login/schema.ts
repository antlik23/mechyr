import { z } from 'zod';
import * as m from '$paraglide/messages';

export const loginFormSchema = z.object({
  email: z.string().email({ message: m.invalidEmail() }).min(1, { message: m.fieldIsRequired() }),
  password: z.string().min(1, { message: m.fieldIsRequired() }),
});

export type LoginFormSchema = typeof loginFormSchema;
export type LoginFormSchemaTypes = z.infer<typeof loginFormSchema>;
