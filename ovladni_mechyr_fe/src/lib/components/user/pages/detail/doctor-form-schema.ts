import { z } from 'zod';
import * as m from '$paraglide/messages';

export const doctorFormSchema = z.object({
  full_name: z.string().min(1, { message: m.fieldIsRequired() }),
  workplace: z.string().min(1, { message: m.fieldIsRequired() }),
  contact_email: z.string().email({ message: m.fieldIsRequired() }),
  contact_phone: z.string().min(1, { message: m.fieldIsRequired() }),
  web: z.string().nullable(),
  city: z.string().min(1, { message: m.fieldIsRequired() }),
  working_hours: z.string().min(1, { message: m.fieldIsRequired() }),
  postal_code: z.number().positive({ message: m.fieldMustBePositiveNumber() }),
  street_and_number: z.string().min(1, { message: m.fieldIsRequired() }),
  specialization: z.enum(['general', 'urologist', 'gynecologist', 'urogynecologist'], {
    message: m.fieldIsRequired(),
  }),
});

export type DoctorFormSchema = typeof doctorFormSchema;
export type DoctorFormSchemaTypes = z.infer<DoctorFormSchema>;

