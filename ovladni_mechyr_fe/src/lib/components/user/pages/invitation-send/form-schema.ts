import { z } from 'zod';
import * as m from '$paraglide/messages';

export const invitationFormSchema = z.object({
  email: z.string().email({ message: m.invalidEmail() }).min(1, { message: m.fieldIsRequired() }),
});

export type InvitationFormSchema = typeof invitationFormSchema;
export type InvitationFormSchemaTypes = z.infer<typeof invitationFormSchema>;
