import * as m from '$paraglide/messages.js';
import { z } from 'zod';

// Updated regex to allow multiple spaces, dots, or dashes throughout the number
const phoneRegex = /^(\+|00)?[1-9][\d\s.-]{1,17}$/;

export const contactDoctorFormSchema = z
  .object({
    custom_message: z.string().min(1, { message: m.fieldIsRequired() }),
    phone_number: z
      .string()
      .optional()
      .refine(
        (val) => {
          if (!val || val.length === 0) return true;
          // Remove spaces for validation but keep original format
          const cleanedNumber = val.replace(/[\s.-]/g, '');
          // Check if cleaned number has at least 4 digits and at most 15 digits
          return cleanedNumber.length >= 4 && cleanedNumber.length <= 15 && phoneRegex.test(val);
        },
        {
          message: 'Zadejte platné telefonní číslo (např. +420 123 456 789)',
        }
      ),
    preferred_contact: z.enum(['email', 'phone']).optional(),
    agreed_to_share_info: z.literal(true, {
      errorMap: () => ({ message: m.fieldIsRequired() }),
    }),
  })
  .superRefine((data, ctx) => {
    // If preferred contact is 'phone', phone_number is required
    if (
      data.preferred_contact === 'phone' &&
      (!data.phone_number || data.phone_number.length === 0)
    ) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: m.fieldIsRequired(),
        path: ['phone_number'],
      });
    }
  });

export type ContactDoctorFormSchema = typeof contactDoctorFormSchema;
export type ContactDoctorFormSchemaTypes = z.infer<ContactDoctorFormSchema>;
