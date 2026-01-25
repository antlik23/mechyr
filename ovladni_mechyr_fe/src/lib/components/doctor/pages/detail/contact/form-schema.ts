import * as m from '$paraglide/messages.js';
import { z } from 'zod';

export const contactDoctorFormSchema = z.object({
  custom_message: z.string().min(1, { message: m.fieldIsRequired() }),
  agreed_to_share_info: z.literal(true, {
    errorMap: () => ({ message: m.fieldIsRequired() }),
  }),
});

export type ContactDoctorFormSchema = typeof contactDoctorFormSchema;
export type ContactDoctorFormSchemaTypes = z.infer<ContactDoctorFormSchema>;
